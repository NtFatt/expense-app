import 'package:flutter/material.dart';

class StateFeedbackCard extends StatelessWidget {
  const StateFeedbackCard({
    super.key,
    required this.child,
    this.minHeight = 280,
  });

  final Widget child;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Center(child: child),
    );
  }
}
