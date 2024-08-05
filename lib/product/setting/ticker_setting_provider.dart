// ticker_setting_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tickerwatch/product/setting/ticker_setting.dart';

final tickerSettingProvider =
    StateNotifierProvider<TickerSettingNotifier, TickerSetting>((ref) {
  return TickerSettingNotifier();
});

class TickerSettingNotifier extends StateNotifier<TickerSetting> {
  late Box<TickerSetting> _tickerSettingBox;

  TickerSettingNotifier()
      : super(TickerSetting(
          candleColor: 'red-blue',
          isLightMode: true,
          isBorderEnabled: true,
          isPriceBackgroundAlarmEnabled: true,
          isQuoteUnitSignEnabled: true,
          isPercentSignEnabled: true,
        )) {
    _init();
  }

  Future<void> _init() async {
    _tickerSettingBox = await Hive.openBox<TickerSetting>('tickerSettingBox');
    if (_tickerSettingBox.isNotEmpty) {
      state = _tickerSettingBox.get(0)!;
    } else {
      _tickerSettingBox.put(0, state);
    }
  }

  void updateBox(TickerSetting tickerSetting) {
    _tickerSettingBox.put(0, tickerSetting);
    state = tickerSetting;
  }

  void resetBox() {
    _tickerSettingBox.clear();
    state = TickerSetting(
      candleColor: 'red-blue',
      isLightMode: true,
      isBorderEnabled: true,
      isPriceBackgroundAlarmEnabled: true,
      isQuoteUnitSignEnabled: true,
      isPercentSignEnabled: true,
    );
    _tickerSettingBox.put(0, state);
  }
}
