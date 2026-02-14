import 'dart:io';

import 'package:flasher/repository/io_backend_repository.dart';
import 'package:flasher/repository/user_file_repository.dart';

class Repositories {
  static Repositories? _instance;
  final IOBackendRepository ioBackendRepository;
  final UserFileRepository userFileRepository;

  const Repositories._({
    required this.ioBackendRepository,
    required this.userFileRepository,
  });

  factory Repositories.init() {

    final IOBackendRepository ioBackendRepository;


    _instance = Repositories._(
      ioBackendRepository: ioBackendRepository,
      userFileRepository: const UserFileRepository(),
    );
    return _instance!;
  }

  factory Repositories() {
    if (_instance == null) {
      throw Exception('Repositories not initialized, call Repositories.init() first');
    }
    return _instance!;
  }

}
