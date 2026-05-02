import 'package:flutter/material.dart';

class DeleteTransactionDialog extends StatelessWidget {
  const DeleteTransactionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Xóa giao dịch?'),
      content: const Text('Thao tác này không thể hoàn tác.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFDC2626),
            foregroundColor: Colors.white,
          ),
          child: const Text('Xóa'),
        ),
      ],
    );
  }
}
