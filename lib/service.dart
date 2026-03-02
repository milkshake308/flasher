import 'dart:async';

import 'package:flasher/models/io_progress.dart';
import 'package:flasher/models/target_disk.dart';
import 'package:flasher/models/user_file.dart';
import 'package:flasher/repository/io_backend_repository.dart';
import 'package:flasher/repository/repositories.dart';
import 'package:flasher/repository/user_file_repository.dart';

class FlashService {
  final IOBackendRepository _ioBackendRepo;
  final UserFileRepository _fileRepo;

  static const chunkSize = 4 * 1024 * 1024;

  FlashService({required Repositories repositories})
    : _ioBackendRepo = repositories.ioBackendRepository,
      _fileRepo = repositories.userFileRepository;

  Stream<IoProgress> flashDiskWithProgress(
    UserFile sourceFile,
    TargetDisk destinationDisk,
  ) async* {
    if (sourceFile.size > destinationDisk.size) {
      throw Exception("Source image file is bigger than destination disk");
    }

    final destinationWriter = await _ioBackendRepo.createIoWriter(
      destinationDisk,
      chunkSize,
    );
    final sourceStream = _fileRepo.readStreamWithGuard(
      sourceFile,
      chunkSize,
      destinationWriter.guard,
    );

    final progress = IoProgress(current: 0, total: sourceFile.size);
    try {
      await for (final chunk in sourceStream) {
        destinationWriter.add(chunk);
        await destinationWriter.flush();

        progress.current += chunk.length;
        yield progress;
      }
    } finally {
      await destinationWriter.finish();
    }
  }
}
