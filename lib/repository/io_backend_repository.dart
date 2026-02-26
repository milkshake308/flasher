import 'dart:convert';
import 'dart:io';

import 'package:flasher/flasher/io_writer.dart';
import 'package:flasher/models/errors.dart';
import 'package:flasher/models/target_disk.dart';

abstract interface class IOBackendRepository {
  Future<IOWriter> createIoWriter(TargetDisk targetDisk, int blockSize);
  Future<List<TargetDisk>> enumerateTargetDisks();
}

class LinuxIOBackendRepository implements IOBackendRepository {

  static const sysFsRealDiskPrefixes = {
    "sd",
    "nvme",
    "mmcblk",
  }; // SCSI, NVMe, SD/eMMC interface

  final Set<String> lockedDisks = {};

  LinuxIOBackendRepository();

  @override
  Future<IOWriter> createIoWriter(TargetDisk targetDisk, int blockSize) async {

    if (lockedDisks.contains(targetDisk.path)) {
      throw IoBackendRepositoryError('Target disk ${targetDisk.path} is currently locked by another operation');
    }

    lockedDisks.add(targetDisk.path);

    final process = await Process.start('dd', [
      'of=${targetDisk.path}',
      'bs=$blockSize',
      'iflag=fullblock',
      'oflag=direct',
    ]);

    Future<void> concludeOperation() async {
      final rc = await process.exitCode;
      lockedDisks.remove(targetDisk.path);
      if (rc != 0) {
        final message = await process.stderr.transform(utf8.decoder).join();
        throw IoBackendRepositoryError('copy process failed with: $message');
      }
    }

    return IOWriter.withFinalizer(
      sink: process.stdin,
      finalizer: concludeOperation,
    );
  }

  @override
  Future<List<TargetDisk>> enumerateTargetDisks() async {
    final Iterable<Directory> devices = (await Directory(
      '/sys/block',
    ).list().toList()).whereType<Directory>();

    final List<TargetDisk> targetDisks = [];

    for (final device in devices) {
      // Filter out devices we dont care about
      final deviceName = device.path.split('/').last;
      if (!sysFsRealDiskPrefixes.any(
        (prefix) => deviceName.startsWith(prefix),
      )) {
        continue;
      }

      final sanitizedDeviceSize = await File(
        '${device.path}/size',
      ).readAsString();
      // /sys/bloc/<dev>/size reports number of 512 byte sectors
      final deviceSize = int.parse(sanitizedDeviceSize) * 512;

      final deviceModel = (await File(
        '${device.path}/device/model',
      ).readAsString()).trim();

      final deviceNode = '/dev/${device.path.split('/').last}';

      targetDisks.add(
        TargetDisk(
          path: deviceNode,
          devname: deviceName,
          size: deviceSize,
          model: deviceModel,
        ),
      );
    }

    return targetDisks;
  }
}
