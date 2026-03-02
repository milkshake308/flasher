import 'package:flutter/material.dart';

class FlashErrorPresenter {
  const FlashErrorPresenter._();

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String body,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Dismiss'),
            ),
          ],
        );
      },
    );
    return;
  }
}
