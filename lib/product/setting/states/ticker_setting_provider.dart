// ticker_setting_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tickerwatch/product/default/db/setting_box_key_enum.dart';
import 'package:tickerwatch/product/setting/entities/ticker_setting.dart';

import '../../default/db/box_enum.enum.dart';
import 'common_setting_provider.dart';

// Color와 String 간 변환 함수
Color stringToColor(String colorString, {bool isDarkMode = false}) {
  switch (colorString) {
    case 'red':
      return Colors.red;
    case 'blue':
      return Colors.blue;
    case 'green':
      return Colors.green;
    case 'grey':
      return Colors.grey;
    // normal
    default:
      return isDarkMode ? Colors.white : Colors.black;
  }
}

String colorToString(Color color, {bool isDarkMode = false}) {
  if (color == Colors.red) {
    return 'red';
  } else if (color == Colors.blue) {
    return 'blue';
  } else if (color == Colors.green) {
    return 'green';
  } else if (color == Colors.grey) {
    return 'grey';
    // normal
  } else {
    return 'primary';
  }
}

final tickerSettingProvider =
    StateNotifierProvider<TickerSettingNotifier, TickerSetting>((ref) {
  final isDarkMode = ref.watch(commonSettingProvider).isDarkMode;
  return TickerSettingNotifier(isDarkMode: isDarkMode);
});

final TickerSetting defaultTickerSetting = TickerSetting(
  longColor: Colors.red,
  shortColor: Colors.blue,
  isBorderEnabled: true,
  isPriceBackgroundAlarmEnabled: true,
  isQuoteUnitSignEnabled: false,
  isPercentSignEnabled: true,
);

class TickerSettingNotifier extends StateNotifier<TickerSetting> {
  late Box<String> _tickerSettingBox;
  final bool isDarkMode;

  TickerSettingNotifier({required this.isDarkMode})
      : super(defaultTickerSetting) {
    _init();
  }

  Future<void> _init() async {
    _tickerSettingBox = await Hive.openBox<String>(BoxEnum.setting.name);
    final String longColorString = _tickerSettingBox.get(
      SettingBoxKeyEnum.longColor.name,
      defaultValue:
          colorToString(defaultTickerSetting.longColor, isDarkMode: isDarkMode),
    )!;
    final String shortColorString = _tickerSettingBox.get(
      SettingBoxKeyEnum.shortColor.name,
      defaultValue: colorToString(defaultTickerSetting.shortColor,
          isDarkMode: isDarkMode),
    )!;
    final bool isBorderEnabled = _tickerSettingBox.get(
          SettingBoxKeyEnum.isBorderEnabled.name,
          defaultValue: defaultTickerSetting.isBorderEnabled.toString(),
        )! ==
        'true';
    final bool isPriceBackgroundAlarmEnabled = _tickerSettingBox.get(
          SettingBoxKeyEnum.isPriceBackgroundAlarmEnabled.name,
          defaultValue:
              defaultTickerSetting.isPriceBackgroundAlarmEnabled.toString(),
        )! ==
        'true';
    final bool isQuoteUnitSignEnabled = _tickerSettingBox.get(
          SettingBoxKeyEnum.isQuoteUnitSignEnabled.name,
          defaultValue: defaultTickerSetting.isQuoteUnitSignEnabled.toString(),
        )! ==
        'true';
    final bool isPercentSignEnabled = _tickerSettingBox.get(
          SettingBoxKeyEnum.isPercentSignEnabled.name,
          defaultValue: defaultTickerSetting.isPercentSignEnabled.toString(),
        )! ==
        'true';

    state = TickerSetting(
      longColor: stringToColor(longColorString, isDarkMode: isDarkMode),
      shortColor: stringToColor(shortColorString, isDarkMode: isDarkMode),
      isBorderEnabled: isBorderEnabled,
      isPriceBackgroundAlarmEnabled: isPriceBackgroundAlarmEnabled,
      isQuoteUnitSignEnabled: isQuoteUnitSignEnabled,
      isPercentSignEnabled: isPercentSignEnabled,
    );
  }

  void updateCandleColor(String newColor) {
    String longColorString = newColor.split('-').firstOrNull ?? 'red';
    String shortColorString = newColor.split('-').lastOrNull ?? 'blue';
    _tickerSettingBox.put(SettingBoxKeyEnum.longColor.name, longColorString);
    _tickerSettingBox.put(SettingBoxKeyEnum.shortColor.name, shortColorString);
    state = state.copyWith(
      longColor: stringToColor(longColorString, isDarkMode: isDarkMode),
      shortColor: stringToColor(shortColorString, isDarkMode: isDarkMode),
    );
  }

  void updateBox(TickerSetting tickerSetting) {
    _tickerSettingBox.put(
      SettingBoxKeyEnum.longColor.name,
      colorToString(tickerSetting.longColor, isDarkMode: isDarkMode),
    );
    _tickerSettingBox.put(
      SettingBoxKeyEnum.shortColor.name,
      colorToString(tickerSetting.shortColor, isDarkMode: isDarkMode),
    );
    _tickerSettingBox.put(
      SettingBoxKeyEnum.isBorderEnabled.name,
      tickerSetting.isBorderEnabled.toString(),
    );
    _tickerSettingBox.put(
      SettingBoxKeyEnum.isPriceBackgroundAlarmEnabled.name,
      tickerSetting.isPriceBackgroundAlarmEnabled.toString(),
    );
    _tickerSettingBox.put(
      SettingBoxKeyEnum.isQuoteUnitSignEnabled.name,
      tickerSetting.isQuoteUnitSignEnabled.toString(),
    );
    _tickerSettingBox.put(
      SettingBoxKeyEnum.isPercentSignEnabled.name,
      tickerSetting.isPercentSignEnabled.toString(),
    );
    state = tickerSetting;
  }
}
