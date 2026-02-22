import 'package:flasher/models/target_disk.dart';
import 'package:flasher/widgets/target_disk_widget.dart';
import 'package:flutter/material.dart';

class DiskSelectionSection extends StatelessWidget {
  final Future<List<TargetDisk>> targetDisksFuture;
  final TargetDisk? selectedDisk;
  final ValueChanged<TargetDisk> onTargetDiskTap;

  const DiskSelectionSection({
    super.key,
    required this.targetDisksFuture,
    required this.selectedDisk,
    required this.onTargetDiskTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Target Disk', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<TargetDisk>>(
                future: targetDisksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
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

                  return ListView.separated(
                    itemCount: targetDisks.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final targetDisk = targetDisks[index];
                      final isSelected = selectedDisk?.path == targetDisk.path;

                      return TargetDiskCard(
                        targetDisk: targetDisk,
                        selected: isSelected,
                        onTap: () => onTargetDiskTap(targetDisk),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
