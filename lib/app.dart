import 'package:flasher/models/target_disk.dart';
import 'package:flasher/repository/repositories.dart';
import 'package:flasher/widgets/disk_selection_section.dart';
import 'package:flutter/material.dart';

class FlasherApp extends StatefulWidget {
  const FlasherApp({super.key});

  @override
  State<FlasherApp> createState() => _FlasherAppState();
}

class _FlasherAppState extends State<FlasherApp> {
  final Future<List<TargetDisk>> _targetDisksFuture = Repositories()
      .ioBackendRepository
      .enumerateTargetDisks();
  TargetDisk? _selectedDisk;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Flasher')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700, maxHeight: 800),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose an image file, select a target disk, then start flashing.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Expanded(
                    child: DiskSelectionSection(
                      targetDisksFuture: _targetDisksFuture,
                      selectedDisk: _selectedDisk,
                      onTargetDiskTap: (targetDisk) {
                        setState(() {
                          _selectedDisk = targetDisk;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
