// ticker_setting.dart

import 'package:flutter/material.dart';

class TickerSetting {
  Color longColor;
  Color shortColor;
  bool isBorderEnabled;
  bool isPriceBackgroundAlarmEnabled;
  bool isQuoteUnitSignEnabled;
  bool isPercentSignEnabled;

  TickerSetting({
    required this.longColor,
    required this.shortColor,
    required this.isBorderEnabled,
    required this.isPriceBackgroundAlarmEnabled,
    required this.isQuoteUnitSignEnabled,
    required this.isPercentSignEnabled,
  });

  TickerSetting copyWith({
    Color? longColor,
    Color? shortColor,
    bool? isBorderEnabled,
    bool? isPriceBackgroundAlarmEnabled,
    bool? isQuoteUnitSignEnabled,
    bool? isPercentSignEnabled,
  }) {
    return TickerSetting(
      longColor: longColor ?? Colors.red,
      shortColor: shortColor ?? Colors.blue,
      isBorderEnabled: isBorderEnabled ?? this.isBorderEnabled,
      isPriceBackgroundAlarmEnabled:
          isPriceBackgroundAlarmEnabled ?? this.isPriceBackgroundAlarmEnabled,
      isQuoteUnitSignEnabled:
          isQuoteUnitSignEnabled ?? this.isQuoteUnitSignEnabled,
      isPercentSignEnabled: isPercentSignEnabled ?? this.isPercentSignEnabled,
    );
  }
}
