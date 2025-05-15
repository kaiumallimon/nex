import 'package:flutter/material.dart';

void customDialog(BuildContext context, String title, String text) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
          ],
        ),
  );
}
