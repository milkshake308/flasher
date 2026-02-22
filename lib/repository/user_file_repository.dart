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

  Stream<List<int>> readStream(UserFile userFile) {
    return File(userFile.path).openRead();
  }
}
