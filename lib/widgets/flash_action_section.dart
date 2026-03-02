import 'package:flasher/widgets/progress_filled_button.dart';
import 'package:flutter/material.dart';

class FlashActionSection extends StatelessWidget {
  final bool canFlash;
  final bool isFlashing;
  final double progress;
  final String label;
  final VoidCallback onPress;

  const FlashActionSection({
    super.key,
    required this.canFlash,
    required this.isFlashing,
    required this.progress,
    required this.label,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProgressFilledButton(
              onPressed: canFlash && !isFlashing ? onPress : null,
              showProgress: isFlashing,
              progress: progress,
              icon: Icons.bolt_rounded,
              label: label,
            ),
          ],
        ),
      ),
    );
  }
}
