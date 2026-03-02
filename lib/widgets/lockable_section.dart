import 'package:flutter/material.dart';

class LockableSection extends StatelessWidget {
  final bool locked;
  final Widget child;

  const LockableSection({super.key, required this.locked, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        AbsorbPointer(
          absorbing: locked,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            opacity: locked ? 0.5 : 1.0,
            child: child,
          ),
        ),
        if (locked)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const SizedBox.shrink(),
            ),
          ),
      ],
    );
  }
}
