class UserFile {
  final int size;
  final String path;

  const UserFile({
    required this.size,
    required this.path,
  });

  String get prettySize {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = this.size.toDouble();
    var suffixIndex = 0;

    while (size >= 1024 && suffixIndex < suffixes.length - 1) {
      size /= 1024;
      suffixIndex++;
    }

    return '${size.toStringAsFixed(2)} ${suffixes[suffixIndex]}';
  }
}
