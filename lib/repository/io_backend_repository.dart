import 'dart:convert';
import 'dart:io';

import 'package:flasher/io_writer.dart';
import 'package:flasher/models/target_disk.dart';

abstract interface class IOBackendRepository {
  Future<IOWriter> createIoWriter(TargetDisk targetDisk);
  Future<List<TargetDisk>> enumerateTargetDisks();
}

class LinuxIOBackendRepository implements IOBackendRepository {
  final int chunkSize;

  static const sysFsRealDiskPrefixes = {
    "sd",
    "nvme",
    "mmcblk",
  }; // SCSI, NVMe, SD/eMMC interface

  const LinuxIOBackendRepository({this.chunkSize = 8 * 1024 * 1024});

  @override
  Future<IOWriter> createIoWriter(TargetDisk targetDisk) async {
    final process = await Process.start('dd', [
      'of=${targetDisk.path}',
      'bs=$chunkSize',
      'oflag=direct',
    ]);

    Future<void> concludeOperation() async {
      final rc = await process.exitCode;
      if (rc != 0) {
        final message = await process.stderr.transform(utf8.decoder).join();
        throw Exception('copy process failed with: $message');
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
      if (!sysFsRealDiskPrefixes.any((prefix) => deviceName.startsWith(prefix))) {
        continue;
      }

      final sanitizedDeviceSize = await File(
        '${device.path}/size',
      ).readAsString();
      final deviceSize = int.parse(sanitizedDeviceSize);
      final deviceModel = await File(
        '${device.path}/device/model',
      ).readAsString();

      targetDisks.add(
        TargetDisk(
          path: device.path,
          devname: deviceName,
          size: deviceSize,
          model: deviceModel,
        ),
      );
    }

    return targetDisks;
  }
}
