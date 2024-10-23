// ticker_setting.dart

import 'package:flutter/material.dart';

class TickerSetting {
  Color? upColor;
  Color? downColor;
  bool? isBorderEnabled;
  int? borderBlinkMilliseconds;
  bool? isPriceBackgroundAlarmEnabled;
  bool? isQuoteUnitSignEnabled;
  bool? isPercentSignEnabled;

  TickerSetting({
    required this.upColor,
    required this.downColor,
    required this.isBorderEnabled,
    required this.borderBlinkMilliseconds,
    required this.isPriceBackgroundAlarmEnabled,
    required this.isQuoteUnitSignEnabled,
    required this.isPercentSignEnabled,
  });

  TickerSetting copyWith({
    Color? upColor,
    Color? downColor,
    bool? isBorderEnabled,
    int? borderBlinkMilliseconds,
    bool? isPriceBackgroundAlarmEnabled,
    bool? isQuoteUnitSignEnabled,
    bool? isPercentSignEnabled,
  }) {
    return TickerSetting(
      upColor: upColor ?? this.upColor,
      downColor: downColor ?? this.downColor,
      isBorderEnabled: isBorderEnabled ?? this.isBorderEnabled,
      borderBlinkMilliseconds:
          borderBlinkMilliseconds ?? this.borderBlinkMilliseconds,
      isPriceBackgroundAlarmEnabled:
          isPriceBackgroundAlarmEnabled ?? this.isPriceBackgroundAlarmEnabled,
      isQuoteUnitSignEnabled:
          isQuoteUnitSignEnabled ?? this.isQuoteUnitSignEnabled,
      isPercentSignEnabled: isPercentSignEnabled ?? this.isPercentSignEnabled,
    );
  }
}
