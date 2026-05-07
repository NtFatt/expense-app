import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:flutter/material.dart';

class DeleteTransactionDialog extends StatelessWidget {
  const DeleteTransactionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.strings.t(AppStringKey.deleteTransactionTitle)),
      content: Text(context.strings.t(AppStringKey.deleteTransactionMessage)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.strings.t(AppStringKey.cancel)),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFDC2626),
            foregroundColor: Colors.white,
          ),
          child: Text(context.strings.t(AppStringKey.delete)),
        ),
      ],
    );
  }
}
