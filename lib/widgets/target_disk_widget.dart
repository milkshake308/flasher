import 'package:flasher/models/target_disk.dart';
import 'package:flutter/material.dart';

class TargetDiskCard extends StatelessWidget {
  final TargetDisk targetDisk;

  const TargetDiskCard({super.key, required this.targetDisk});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.save),
            title: Text('${targetDisk.model} • ${targetDisk.devname}'),
            subtitle: Text(targetDisk.path),
            trailing: Text(targetDisk.prettySize),
          ),
        ],
      ),
    );
  }
}
