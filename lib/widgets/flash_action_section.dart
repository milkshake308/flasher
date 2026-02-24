import 'package:flutter/material.dart';

class FlashActionSection extends StatelessWidget {
  final bool canFlash;
  final VoidCallback onPress;

  const FlashActionSection({
    super.key,
    required this.canFlash,
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
              onPressed: canFlash ? onPress : null,
              icon: const Icon(Icons.bolt_rounded),
              label: const Text('Flash Image'),
            ),
          ],
        ),
      ),
    );
  }
}
