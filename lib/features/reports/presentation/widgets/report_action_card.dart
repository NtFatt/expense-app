import 'package:flutter/material.dart';

class ReportActionCard extends StatelessWidget {
  const ReportActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onPressed,
    this.buttonIcon = Icons.download_rounded,
    this.secondaryButtonLabel,
    this.onSecondaryPressed,
    this.secondaryButtonIcon = Icons.upload_file_rounded,
  });

  final IconData icon;
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback? onPressed;
  final IconData buttonIcon;
  final String? secondaryButtonLabel;
  final VoidCallback? onSecondaryPressed;
  final IconData secondaryButtonIcon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Widget iconChip = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: const Color(0xFF2563EB)),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Widget content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: onPressed,
                    icon: Icon(buttonIcon),
                    label: Text(buttonLabel),
                  ),
                  if (secondaryButtonLabel != null &&
                      onSecondaryPressed != null)
                    OutlinedButton.icon(
                      onPressed: onSecondaryPressed,
                      icon: Icon(secondaryButtonIcon),
                      label: Text(secondaryButtonLabel!),
                    ),
                ],
              ),
            ],
          );

          if (constraints.maxWidth < 420) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[iconChip, const SizedBox(height: 14), content],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              iconChip,
              const SizedBox(width: 16),
              Expanded(child: content),
            ],
          );
        },
      ),
    );
  }
}
