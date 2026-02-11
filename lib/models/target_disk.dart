import 'dart:convert';
import 'dart:io';

import 'package:flasher/io_writter.dart';

class TargetDisk {
  final String path;
  final String label;
  final int size;
  final String model;

  const TargetDisk({
    required this.path,
    required this.label,
    required this.size,
    required this.model,
  });

  Future<IOWritter> _linuxIoWritter(
    String targetDiskPath,
    int chunkSize,
  ) async {
    final process = await Process.start('dd', [
      'of=$targetDiskPath',
      'bs=$chunkSize',
      'oflag=direct',
    ]);

    Future<void> concludeOperation() async {
      final rc = await process.exitCode;
      final message = await process.stderr.transform(utf8.decoder).join();
      if (rc != 0) {
        process.stdin.addError(
          Exception('IOSink Process failed with: $message'),
        );
      }
    }

    return IOWritter.withFinalizer(
      sink: process.stdin,
      finalizer: concludeOperation,
    );
  }

  Future<IOWritter> ioWritterFromPlatform() async {
    if (Platform.isLinux) {
      final chunkSize = 8 * 1024 * 1024;
      return await _linuxIoWritter(path, chunkSize);
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

}