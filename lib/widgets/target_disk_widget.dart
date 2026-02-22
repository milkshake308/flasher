import 'package:flasher/models/target_disk.dart';
import 'package:flutter/material.dart';

class TargetDiskCard extends StatelessWidget {
  final TargetDisk targetDisk;
  final bool selected;
  final VoidCallback? onTap;

  const TargetDiskCard({
    super.key,
    required this.targetDisk,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: selected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap,
            child: ListTile(
              leading: const Icon(Icons.save_alt_rounded),
              title: Text('${targetDisk.model} • ${targetDisk.devname}'),
              subtitle: Text(targetDisk.path),
              trailing: Text(targetDisk.prettySize),
            ),
          ),
        ],
      ),
    );
  }
}
