import 'package:flutter/material.dart';

class FlashActionSection extends StatelessWidget {
  final bool canFlash;
  final bool isFlashing;
  final VoidCallback onPress;

  const FlashActionSection({
    super.key,
    required this.canFlash,
    required this.isFlashing,
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
            FilledButton.icon(
              onPressed: canFlash && !isFlashing ? onPress : null,
              icon:  const Icon(Icons.bolt_rounded),
              label: Text(isFlashing ? 'Flashing...' : 'Flash Image'),
            ),
          ],
        ),
      ),
    );
  }
}
