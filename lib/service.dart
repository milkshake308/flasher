import 'dart:async';

import 'package:flasher/models/target_disk.dart';
import 'package:flasher/models/user_file.dart';
import 'package:flasher/repository/io_backend_repository.dart';
import 'package:flasher/repository/repositories.dart';
import 'package:flasher/repository/user_file_repository.dart';

class FlashService {
  final IOBackendRepository _ioBackendRepository;
  final UserFileRepository _userFileRepository;

  FlashService({
    required Repositories repositories,
  }) : _ioBackendRepository = repositories.ioBackendRepository,
       _userFileRepository = repositories.userFileRepository;

  Future<void> flashDisk(
    UserFile sourceFile,
    TargetDisk destinationDisk,
  ) async {
    final sourceStream = _userFileRepository.readStream(sourceFile);
    final destinationWritter = await _ioBackendRepository.createIoWriter(
      destinationDisk,
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
