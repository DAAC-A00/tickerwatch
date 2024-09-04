// custom_theme.dart

import 'package:flutter/material.dart';

class CustomTheme {
  const CustomTheme({required this.baseSize});

  final double baseSize;

  // static final Color toastBackgroundLight = Colors.grey.shade300;
  // static final Color toastBackgroundDark = Colors.grey.shade900;

  static TextStyle _getDisplayStyle(double referenceSize) =>
      TextStyle(fontSize: referenceSize / 15 * 4);
  static TextStyle _getHeadLineStyle(double referenceSize) =>
      TextStyle(fontSize: referenceSize / 9);
  static TextStyle _getTitleStyle(double referenceSize) =>
      TextStyle(fontSize: referenceSize / 15);
  static TextStyle _getBodyStyle(double referenceSize) =>
      TextStyle(fontSize: referenceSize / 45 * 2);
  static TextStyle _getLabelStyle(double referenceSize) =>
      TextStyle(fontSize: referenceSize / 180 * 7);
  // , fontFamily: 'Pretendard'

  static TextTheme _getTextTheme(double baseSize) {
    return TextTheme(
      displayLarge: _getDisplayStyle(baseSize),
      displayMedium: _getDisplayStyle(baseSize / 8 * 5),
      displaySmall: _getDisplayStyle(baseSize / 8 * 4),
      headlineLarge: _getHeadLineStyle(baseSize),
      headlineMedium: _getHeadLineStyle(baseSize / 20 * 17),
      headlineSmall: _getHeadLineStyle(baseSize / 20 * 12),
      titleLarge: _getTitleStyle(baseSize),
      titleMedium: _getTitleStyle(baseSize / 6 * 5),
      titleSmall: _getTitleStyle(baseSize / 6 * 4),
      bodyLarge: _getBodyStyle(baseSize),
      bodyMedium: _getBodyStyle(baseSize / 8 * 7),
      bodySmall: _getBodyStyle(baseSize / 8 * 6),
      labelLarge: _getLabelStyle(baseSize),
      labelMedium: _getLabelStyle(baseSize / 7 * 6),
      labelSmall: _getLabelStyle(baseSize / 7 * 5),
    );
  }

  ThemeData get lightThemeData => ThemeData(
        useMaterial3: true,
        fontFamily: 'Pretendard',
        textTheme: _getTextTheme(baseSize), // mobile Device baseSize 360
        colorScheme: const ColorScheme.light(
          brightness: Brightness.light,
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.grey,
          onSecondary: Colors.black,
          tertiary: Colors.white,
          onTertiary: Colors.grey,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
          ),
        ),
      );

  ThemeData get darkThemeData => ThemeData(
        useMaterial3: true,
        fontFamily: 'Pretendard',
        textTheme: _getTextTheme(baseSize),
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.grey,
          onSecondary: Colors.white,
          tertiary: Colors.black,
          onTertiary: Colors.grey,
          error: Colors.red,
          onError: Colors.black,
          surface: Colors.black,
          onSurface: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
          ),
        ),
      );
}
