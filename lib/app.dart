import 'package:file_selector/file_selector.dart';
import 'package:flasher/models/target_disk.dart';
import 'package:flasher/models/user_file.dart';
import 'package:flasher/repository/repositories.dart';
import 'package:flasher/service.dart';
import 'package:flasher/widgets/disk_selection_section.dart';
import 'package:flasher/widgets/flash_action_section.dart';
import 'package:flasher/widgets/flash_error_presenter.dart';
import 'package:flasher/widgets/image_file_picker_section.dart';
import 'package:flasher/widgets/lockable_section.dart';
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
  UserFile? _selectedImageFile;
  bool _isFlashing = false;
  double _flashProgress = 0;

  Future<XFile?> pickImageFile() async {
    const XTypeGroup imageGroup = XTypeGroup(
      label: 'Disk image',
      extensions: <String>['img', 'iso', 'bin', 'raw'],
    );
    return await openFile(acceptedTypeGroups: const <XTypeGroup>[imageGroup]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final services = FlashService(repositories: Repositories.Of(context));
    final canFlash =
        !_isFlashing && _selectedImageFile != null && _selectedDisk != null;

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
                  LockableSection(
                    locked: _isFlashing,
                    child: ImageFilePickerSection(
                      selectedImagePath: (_selectedImageFile != null)
                          ? _selectedImageFile!.path
                          : null,
                      onBrowsePressed: () async {
                        final imagePath = await pickImageFile();

                        final UserFile? imageFile = (imagePath != null)
                            ? UserFile(
                                path: imagePath.path,
                                size: await imagePath.length(),
                              )
                            : null;

                        if (!mounted) return;
                        setState(() {
                          if (imageFile != null) {
                            _selectedImageFile = imageFile;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: LockableSection(
                      locked: _isFlashing,
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
                  ),
                  const SizedBox(height: 12),
                  FlashActionSection(
                    canFlash: canFlash,
                    isFlashing: _isFlashing,
                    progress: _flashProgress,
                    label: _isFlashing
                        ? 'Flashing ${(_flashProgress * 100).round()}%'
                        : 'Flash Image',
                    onPress: () async {
                      setState(() {
                        _isFlashing = true;
                        _flashProgress = 0;
                      });

                      try {
                        await for (final progress
                            in services.flashDiskWithProgress(
                              _selectedImageFile!,
                              _selectedDisk!,
                            )) {
                          if (!mounted) break;
                          setState(() {
                            _flashProgress = progress.fraction;
                          });
                        }
                      } catch (e) {
                        if (!mounted) return;
                        await FlashErrorPresenter.show(
                          context: context,
                          title: "Flashing error",
                          body: e.toString(),
                        );
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isFlashing = false;
                            _flashProgress = 0;
                          });
                        }
                      }
                    },
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
