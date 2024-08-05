// ticker_setting.dart

import 'package:hive/hive.dart';

class TickerSetting {
  String candleColor;
  bool isLightMode;
  bool isBorderEnabled;
  bool isPriceBackgroundAlarmEnabled;
  bool isQuoteUnitSignEnabled;
  bool isPercentSignEnabled;

  TickerSetting(
      {required this.candleColor,
      required this.isLightMode,
      required this.isBorderEnabled,
      required this.isPriceBackgroundAlarmEnabled,
      required this.isQuoteUnitSignEnabled,
      required this.isPercentSignEnabled});
}

class TickerSettingAdapter extends TypeAdapter<TickerSetting> {
  @override
  final typeId = 0;

  @override
  TickerSetting read(BinaryReader reader) {
    // 바이너리 데이터를 읽어 객체를 생성합니다.
    final candleColor = reader.readString();
    final isLightMode = reader.readBool();
    final isBorderEnabled = reader.readBool();
    final isPriceBackgroundAlarmEnabled = reader.readBool();
    final isQuoteUnitSignEnabled = reader.readBool();
    final isPercentSignEnabled = reader.readBool();
    return TickerSetting(
      candleColor: candleColor,
      isLightMode: isLightMode,
      isBorderEnabled: isBorderEnabled,
      isPriceBackgroundAlarmEnabled: isPriceBackgroundAlarmEnabled,
      isQuoteUnitSignEnabled: isQuoteUnitSignEnabled,
      isPercentSignEnabled: isPercentSignEnabled,
    );
  }

  @override
  void write(BinaryWriter writer, TickerSetting obj) {
    // 객체를 바이너리 데이터로 씁니다.
    writer.writeString(obj.candleColor);
    writer.writeBool(obj.isLightMode);
    writer.writeBool(obj.isBorderEnabled);
    writer.writeBool(obj.isPriceBackgroundAlarmEnabled);
    writer.writeBool(obj.isQuoteUnitSignEnabled);
    writer.writeBool(obj.isPercentSignEnabled);
  }
}
