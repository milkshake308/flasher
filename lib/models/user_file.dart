import 'dart:io';

class UserFile {
  final File _file;
  final int _size;
  final String _path;

  const UserFile._(this._file, this._size, this._path);

  Stream<List<int>> readStream() {
    return _file.openRead();
  }

  factory UserFile.fromFile({
    required File file
  }) {
    if (!file.existsSync()) {
      throw ArgumentError('Provided file does not exist');
    }
    final fstat = file.statSync();
    if (fstat.type != FileSystemEntityType.file) {
      throw ArgumentError('Provided path is not a file'); 
    }
    return UserFile._(file, fstat.size, file.absolute.path);
  }

  int get size => _size;

  String get path => _path;

  String get prettySize {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = _size.toDouble();
    var suffixIndex = 0;

    while (size >= 1024 && suffixIndex < suffixes.length - 1) {
      size /= 1024;
      suffixIndex++;
    }

    return '${size.toStringAsFixed(2)} ${suffixes[suffixIndex]}';
  }
}
