import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final Widget titleText = Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
    );

    if (actionLabel == null || onActionPressed == null) {
      return titleText;
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Widget actionButton = TextButton(
          onPressed: onActionPressed,
          child: Text(actionLabel!),
        );

        if (constraints.maxWidth < 360) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              titleText,
              const SizedBox(height: 6),
              actionButton,
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(child: titleText),
            const SizedBox(width: 12),
            actionButton,
          ],
        );
      },
    );
  }
}
