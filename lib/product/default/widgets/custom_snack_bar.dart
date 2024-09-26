// custom_snack_bar.dart

import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String title, String content) {
  final ColorScheme currentTheme = Theme.of(context).colorScheme;
  final double bodySmallSize =
      Theme.of(context).textTheme.bodySmall?.fontSize ?? 20;
  final double paddingSize = bodySmallSize / 4;

  // SnackBar를 보여주기 전에 hideCurrentSnackBar를 호출하여 현재 Snackbar를 숨깁니다.
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Padding(
        padding: EdgeInsets.only(
          top: paddingSize,
          bottom: 0,
          left: paddingSize,
          right: paddingSize,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' $content',
                ),
              ],
            ),
            Positioned(
              right: -bodySmallSize,
              top: -bodySmallSize,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: currentTheme.onPrimary,
                ),
                onPressed: () {
                  // 현재 context가 여전히 활성화되어 있는지 확인합니다.
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: currentTheme.secondary.withOpacity(0.5),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(bodySmallSize),
      ),
      elevation: 0, // 그림자 없애기
    ),
  );
}
