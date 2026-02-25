import 'dart:io';

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

  Stream<List<int>> readStream(UserFile userFile, int chunkSize) async* {
    final source = await File(userFile.path).open();

    try {
      while (true) {
        final chunk = await source.read(chunkSize);
        if (chunk.isEmpty) break;
        yield chunk;
      }
    } finally {
      source.close();
    }

  }
}
