import 'package:flasher/models/target_disk.dart';
import 'package:flasher/repository/repositories.dart';
import 'package:flasher/widgets/target_disk_widget.dart';
import 'package:flutter/material.dart';

void main() {
  // Initialize repository
  Repositories.init();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainAppState();
  }
}

class _MainAppState extends State<MainApp> {
  final Future<List<TargetDisk>> targetDisksFuture = Repositories()
      .ioBackendRepository
      .enumerateTargetDisks();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<List<TargetDisk>>(
          future: targetDisksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: Text('Loading Disks..'));
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Failed to load disks: ${snapshot.error}'),
              );
            }

            final targetDisks = snapshot.data ?? const <TargetDisk>[];
            if (targetDisks.isEmpty) {
              return const Center(child: Text('No disks found.'));
            }

            return ListView.builder(
              itemCount: targetDisks.length,
              itemBuilder: (context, index) {
                return TargetDiskCard(targetDisk: targetDisks[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
