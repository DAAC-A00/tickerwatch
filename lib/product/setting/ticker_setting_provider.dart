// ticker_setting_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tickerwatch/product/setting/ticker_setting.dart';

import '../default/db/box_enum.enum.dart';

final tickerSettingProvider =
    StateNotifierProvider<TickerSettingNotifier, TickerSetting>((ref) {
  return TickerSettingNotifier();
});

final TickerSetting defaultTickerSetting = TickerSetting(
  candleColor: 'red-blue',
  isBorderEnabled: true,
  isPriceBackgroundAlarmEnabled: true,
  isQuoteUnitSignEnabled: false,
  isPercentSignEnabled: true,
);

class TickerSettingNotifier extends StateNotifier<TickerSetting> {
  late Box<String> _tickerSettingBox;

  TickerSettingNotifier() : super(defaultTickerSetting) {
    _init();
  }

  Future<void> _init() async {
    _tickerSettingBox = await Hive.openBox<String>(BoxEnum.setting.name);
    final String candleColor = _tickerSettingBox.get('candleColor',
        defaultValue: defaultTickerSetting.candleColor)!;
    final bool isBorderEnabled = _tickerSettingBox.get('isBorderEnabled',
            defaultValue: defaultTickerSetting.isBorderEnabled.toString())! ==
        'true';
    final bool isPriceBackgroundAlarmEnabled = _tickerSettingBox.get(
            'isPriceBackgroundAlarmEnabled',
            defaultValue: defaultTickerSetting.isPriceBackgroundAlarmEnabled
                .toString())! ==
        'true';
    final bool isQuoteUnitSignEnabled = _tickerSettingBox.get(
            'isQuoteUnitSignEnabled',
            defaultValue:
                defaultTickerSetting.isQuoteUnitSignEnabled.toString())! ==
        'true';
    final bool isPercentSignEnabled = _tickerSettingBox.get(
            'isPercentSignEnabled',
            defaultValue:
                defaultTickerSetting.isPercentSignEnabled.toString())! ==
        'true';
    state = TickerSetting(
        candleColor: candleColor,
        isBorderEnabled: isBorderEnabled,
        isPriceBackgroundAlarmEnabled: isPriceBackgroundAlarmEnabled,
        isQuoteUnitSignEnabled: isQuoteUnitSignEnabled,
        isPercentSignEnabled: isPercentSignEnabled);
  }

  void updateBox(TickerSetting tickerSetting) {
    _tickerSettingBox.put('candleColor', tickerSetting.candleColor);
    _tickerSettingBox.put(
        'isBorderEnabled', tickerSetting.isBorderEnabled.toString());
    _tickerSettingBox.put('isPriceBackgroundAlarmEnabled',
        tickerSetting.isPriceBackgroundAlarmEnabled.toString());
    _tickerSettingBox.put('isQuoteUnitSignEnabled',
        tickerSetting.isQuoteUnitSignEnabled.toString());
    _tickerSettingBox.put(
        'isPercentSignEnabled', tickerSetting.isPercentSignEnabled.toString());
    state = tickerSetting;
  }

  void deleteBox() {
    _tickerSettingBox.clear();
    state = defaultTickerSetting;
  }
}
