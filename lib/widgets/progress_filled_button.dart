import 'package:flutter/material.dart';

class ProgressFilledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool showProgress;
  final double progress;
  final IconData icon;
  final String label;

  const ProgressFilledButton({
    super.key,
    required this.onPressed,
    required this.showProgress,
    required this.progress,
    required this.icon,
    required this.label,
  }) : assert(progress >= 0.0 && progress <= 1.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilledButton(
      onPressed: onPressed,
      clipBehavior: Clip.hardEdge,
      style: FilledButton.styleFrom(padding: EdgeInsets.zero),
      child: SizedBox(
        height: 32,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedFractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: showProgress ? progress : 0,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              child: ColoredBox(
                color: theme.colorScheme.primary.withValues(alpha: 0.35),
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(icon), const SizedBox(width: 8), Text(label)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
