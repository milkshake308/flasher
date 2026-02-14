import 'package:flasher/flasher/utils.dart';

class TargetDisk {
  final String path;
  final String devname;
  final int size;
  final String model;

  const TargetDisk({
    required this.path,
    required this.devname,
    required this.size,
    required this.model,
  });

  String get prettySize {
    return prettifyByteSize(size);
  }
}
