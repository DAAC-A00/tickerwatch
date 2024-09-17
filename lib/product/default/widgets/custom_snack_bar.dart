// custom_snack_bar.dart

import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context) {
  final ColorScheme currentTheme = Theme.of(context).colorScheme;
  final double paddingSize =
      Theme.of(context).textTheme.bodySmall?.fontSize ?? 20;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Padding(
        padding: EdgeInsets.symmetric(
          vertical: paddingSize / 2,
          horizontal: paddingSize,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '완료',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: currentTheme.onPrimary,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ],
            ),
            const Text(
              '세부 정보가 필요하면 여기를 확인하세요.\n테스트중',
            ),
          ],
        ),
      ),
      // action: SnackBarAction(
      //   label: 'UNDO',
      //   onPressed: () {
      //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //   },
      // ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      // margin: const EdgeInsets.all(16),
    ),
  );
}
