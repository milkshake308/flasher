import 'dart:io';

import 'package:flasher/repository/io_backend_repository.dart';
import 'package:flasher/repository/user_file_repository.dart';
import 'package:flutter/widgets.dart';

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
    if (Platform.isLinux) {
      ioBackendRepository = LinuxIOBackendRepository();
    } else {
      throw UnsupportedError(
        'Unsupported platform: ${Platform.operatingSystem}.',
      );
    }

    _instance = Repositories._(
      ioBackendRepository: ioBackendRepository,
      userFileRepository: const UserFileRepository(),
    );
    return _instance!;
  }

  factory Repositories() {
    if (_instance == null) {
      throw Exception(
        'Repositories not initialized, call Repositories.init() first',
      );
    }
    return _instance!;
  }

  static Repositories of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<RepositoriesProvider>();
    assert(
      provider != null,
      'No RepositoriesProvider found in context. Wrap your widget tree with RepositoriesProvider.',
    );
    return provider!.repositories;
  }

  // ignore: non_constant_identifier_names
  static Repositories Of(BuildContext context) => of(context);
}

class RepositoriesProvider extends InheritedWidget {
  final Repositories repositories;

  const RepositoriesProvider({
    super.key,
    required this.repositories,
    required super.child,
  });

  @override
  bool updateShouldNotify(RepositoriesProvider oldWidget) {
    return repositories != oldWidget.repositories;
  }
}
