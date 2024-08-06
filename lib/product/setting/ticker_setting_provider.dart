// ticker_setting_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tickerwatch/product/setting/ticker_setting.dart';

final tickerSettingProvider =
    StateNotifierProvider<TickerSettingNotifier, TickerSetting>((ref) {
  return TickerSettingNotifier();
});

final defaultTickerSetting = TickerSetting(
  candleColor: 'red-blue',
  isLightMode: true,
  isBorderEnabled: true,
  isPriceBackgroundAlarmEnabled: true,
  isQuoteUnitSignEnabled: true,
  isPercentSignEnabled: true,
);

class TickerSettingNotifier extends StateNotifier<TickerSetting> {
  late Box<TickerSetting> _tickerSettingBox;

  TickerSettingNotifier() : super(defaultTickerSetting) {
    _init();
  }

  Future<void> _init() async {
    _tickerSettingBox = await Hive.openBox<TickerSetting>('tickerSettingBox');
    if (_tickerSettingBox.isNotEmpty) {
      state = _tickerSettingBox.get('last')!;
    } else {
      state = defaultTickerSetting;
      _tickerSettingBox.put('first', state);
      _tickerSettingBox.put('last', state);
    }
  }

  void updateBox(TickerSetting tickerSetting) {
    _tickerSettingBox.put('last', tickerSetting);
    state = tickerSetting;
  }

  void deleteBox() {
    _tickerSettingBox.clear();
    state = defaultTickerSetting;
    _tickerSettingBox.put('first', state);
    _tickerSettingBox.put('last', state);
  }
}
