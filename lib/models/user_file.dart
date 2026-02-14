import 'package:flasher/flasher/utils.dart';

class UserFile {
  final int size;
  final String path;

  const UserFile({
    required this.size,
    required this.path,
  });

  String get prettySize {
    return prettifyByteSize(size); 
  }
}
