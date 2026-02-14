import 'dart:convert';
import 'dart:io';

import 'package:flasher/io_writer.dart';
import 'package:flasher/models/target_disk.dart';

abstract interface class IOBackendRepository {
  Future<IOWriter> createIoWriter(TargetDisk targetDisk);
  Future<List<TargetDisk>> enumerateTargetDisks();
}
