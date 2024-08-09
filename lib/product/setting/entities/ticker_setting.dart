// ticker_setting.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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

// class TickerSettingAdapter extends TypeAdapter<TickerSetting> {
// @override
// final typeId = 0;

// @override
// TickerSetting read(BinaryReader reader) {
// // 바이너리 데이터를 읽어 객체를 생성합니다.
// final ColorColor = reader.readString();
// final isBorderEnabled = reader.readBool();
// final isPriceBackgroundAlarmEnabled = reader.readBool();
// final isQuoteUnitSignEnabled = reader.readBool();
// final isPercentSignEnabled = reader.readBool();
// return TickerSetting(
// ColorColor: ColorColor,
// isBorderEnabled: isBorderEnabled,
// isPriceBackgroundAlarmEnabled: isPriceBackgroundAlarmEnabled,
// isQuoteUnitSignEnabled: isQuoteUnitSignEnabled,
// isPercentSignEnabled: isPercentSignEnabled,
// );
// }

// @override
// void write(BinaryWriter writer, TickerSetting obj) {
// // 객체를 바이너리 데이터로 씁니다.
// writer.writeString(obj.ColorColor);
// writer.writeBool(obj.isBorderEnabled);
// writer.writeBool(obj.isPriceBackgroundAlarmEnabled);
// writer.writeBool(obj.isQuoteUnitSignEnabled);
// writer.writeBool(obj.isPercentSignEnabled);
// }
// }
