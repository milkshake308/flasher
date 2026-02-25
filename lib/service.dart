import 'dart:async';

import 'package:flasher/models/target_disk.dart';
import 'package:flasher/models/user_file.dart';
import 'package:flasher/repository/io_backend_repository.dart';
import 'package:flasher/repository/repositories.dart';
import 'package:flasher/repository/user_file_repository.dart';

class FlashService {
  final IOBackendRepository _ioBackendRepo;
  final UserFileRepository _fileRepo;

  static const chunkSize = 4 * 1024 * 1024;

  FlashService({
    required Repositories repositories,
  }) : _ioBackendRepo = repositories.ioBackendRepository,
       _fileRepo = repositories.userFileRepository;

  Future<void> flashDisk(
    UserFile sourceFile,
    TargetDisk destinationDisk,
  ) async {

    if (sourceFile.size > destinationDisk.size) {
      throw Exception("Source image file is bigger than destination disk");
    }

    final sourceStream = _fileRepo.readStream(sourceFile, chunkSize);
    final destinationWritter = await _ioBackendRepo.createIoWriter(
      destinationDisk, chunkSize
    );

    // IO pump loop 
    try {
      await for (final chunk in sourceStream) {
        destinationWritter.add(chunk);
        await destinationWritter.flush();
      }
    } catch (e) {
      rethrow;
    } finally {
      await destinationWritter.finish();
    }
  }
}
