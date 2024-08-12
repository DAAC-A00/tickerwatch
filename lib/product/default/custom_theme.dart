// custom_theme.dart

import 'package:flutter/material.dart';

class CustomTheme {
  const CustomTheme({required this.baseSize});

  final double baseSize;

  // static final Color toastBackgroundLight = Colors.grey.shade300;
  // static final Color toastBackgroundDark = Colors.grey.shade900;

  static TextStyle _getTitleStyle(double baseSize) =>
      TextStyle(fontSize: baseSize * 0.07);
  static TextStyle _getDisplayStyle(double baseSize) =>
      TextStyle(fontSize: baseSize * 0.06);
  static TextStyle _getBodyStyle(double baseSize) =>
      TextStyle(fontSize: baseSize * 0.05);
  // , fontFamily: 'Pretendard'

  static TextTheme _getTextTheme(double baseSize) {
    return TextTheme(
      titleLarge: _getTitleStyle(baseSize),
      titleMedium: _getTitleStyle(baseSize),
      titleSmall: _getTitleStyle(baseSize),
      displayLarge: _getDisplayStyle(baseSize * 0.7),
      displayMedium: _getDisplayStyle(baseSize * 0.6),
      displaySmall: _getDisplayStyle(baseSize * 0.5),
      bodyLarge: _getBodyStyle(baseSize * 0.9),
      bodyMedium: _getBodyStyle(baseSize * 0.75),
      bodySmall: _getBodyStyle(baseSize * 0.6),
    );
  }

  ThemeData get lightThemeData => ThemeData(
        useMaterial3: true,
        fontFamily: 'Pretendard',
        textTheme: _getTextTheme(baseSize),
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
