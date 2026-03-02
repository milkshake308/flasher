import 'dart:async';
import 'dart:io';

import 'package:flasher/models/errors.dart';
import 'package:flasher/models/user_file.dart';

class UserFileRepository {
  const UserFileRepository();

  UserFile fromFile(File file) {
    if (!file.existsSync()) {
      throw ArgumentError('Provided file does not exist');
    }
    final fstat = file.statSync();
    if (fstat.type != FileSystemEntityType.file) {
      throw ArgumentError('Provided path is not a file');
    }
    return UserFile(size: fstat.size, path: file.absolute.path);
  }

  Stream<List<int>> readStreamWithGuard(
    UserFile userFile,
    int chunkSize,
    Future<void> guard,
  ) async* {
    final source = await File(userFile.path).open();
    final guardFailure = Completer<List<int>>();
    var sourceFinished = false;

    void failGuard(Object error, StackTrace stackTrace) {
      if (sourceFinished || guardFailure.isCompleted) {
        return;
      }

      guardFailure.completeError(error, stackTrace);
    }

    unawaited(
      guard.then<void>(
        (_) => failGuard(
          IoBackendRepositoryError(
            'copy process finished before source stream completed',
          ),
          StackTrace.current,
        ),
        onError: failGuard,
      ),
    );

    try {
      while (true) {
        if (guardFailure.isCompleted) {
          await guardFailure.future;
        }

        final chunk = await Future.any<List<int>>([
          source.read(chunkSize).then<List<int>>((bytes) => bytes),
          guardFailure.future,
        ]);

        if (chunk.isEmpty) {
          sourceFinished = true;
          break;
        }
        yield chunk;
      }
    } finally {
      sourceFinished = true;
      await source.close();
    }
  }
}
