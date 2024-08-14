// ticker_setting_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tickerwatch/product/default/db/box_setting_enum.dart';
import 'package:tickerwatch/product/setting/entities/ticker_setting.dart';

import '../../default/db/box_enum.dart';
import 'common_setting_provider.dart';

// Color와 String 간 변환 함수
Color _stringToColor(String colorString, bool isLightMode) {
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
      return isLightMode ? Colors.black : Colors.white;
  }
}

String colorToString(Color? color) {
  if (color == Colors.red) {
    return 'red';
  } else if (color == Colors.blue) {
    return 'blue';
  } else if (color == Colors.green) {
    return 'green';
  } else if (color == Colors.grey) {
    return 'grey';
  } else if (color == Colors.white || color == Colors.black) {
    return 'primary';
  } else {
    // normal
    return '';
  }
}

final tickerSettingProvider =
    StateNotifierProvider<TickerSettingNotifier, TickerSetting>((ref) {
  final isLightMode = ref.watch(commonSettingProvider).isLightMode;
  return TickerSettingNotifier(isLightMode: isLightMode);
});

final TickerSetting defaultTickerSetting = TickerSetting(
  longColor: null,
  shortColor: null,
  isBorderEnabled: null,
  isPriceBackgroundAlarmEnabled: null,
  isQuoteUnitSignEnabled: null,
  isPercentSignEnabled: null,
);

class TickerSettingNotifier extends StateNotifier<TickerSetting> {
  late Box<String> _tickerSettingBox;
  final bool isLightMode;

  TickerSettingNotifier({required this.isLightMode})
      : super(defaultTickerSetting) {
    _init();
  }

  Future<void> _init() async {
    _tickerSettingBox = await Hive.openBox<String>(BoxEnum.setting.name);
    final String longColorString = _tickerSettingBox.get(
      BoxSettingEnum.longColor.name,
      defaultValue: colorToString(Colors.red),
    )!;
    final String shortColorString = _tickerSettingBox.get(
      BoxSettingEnum.shortColor.name,
      defaultValue: colorToString(Colors.blue),
    )!;
    final bool isBorderEnabled = _tickerSettingBox.get(
          BoxSettingEnum.isBorderEnabled.name,
          defaultValue: true.toString(),
        )! ==
        true.toString();
    final bool isPriceBackgroundAlarmEnabled = _tickerSettingBox.get(
          BoxSettingEnum.isPriceBackgroundAlarmEnabled.name,
          defaultValue: true.toString(),
        )! ==
        true.toString();
    final bool isQuoteUnitSignEnabled = _tickerSettingBox.get(
          BoxSettingEnum.isQuoteUnitSignEnabled.name,
          defaultValue: false.toString(),
        )! ==
        true.toString();
    final bool isPercentSignEnabled = _tickerSettingBox.get(
          BoxSettingEnum.isPercentSignEnabled.name,
          defaultValue: true.toString(),
        )! ==
        true.toString();

    state = TickerSetting(
      longColor: _stringToColor(longColorString, isLightMode),
      shortColor: _stringToColor(shortColorString, isLightMode),
      isBorderEnabled: isBorderEnabled,
      isPriceBackgroundAlarmEnabled: isPriceBackgroundAlarmEnabled,
      isQuoteUnitSignEnabled: isQuoteUnitSignEnabled,
      isPercentSignEnabled: isPercentSignEnabled,
    );
  }

  void updateCandleColor(String newColor) {
    String longColorString = newColor.split('-').firstOrNull ?? 'red';
    String shortColorString = newColor.split('-').lastOrNull ?? 'blue';
    _tickerSettingBox.put(BoxSettingEnum.longColor.name, longColorString);
    _tickerSettingBox.put(BoxSettingEnum.shortColor.name, shortColorString);
    state = state.copyWith(
      longColor: _stringToColor(longColorString, isLightMode),
      shortColor: _stringToColor(shortColorString, isLightMode),
    );
  }

  void updateBox(TickerSetting tickerSetting) {
    _tickerSettingBox.put(
      BoxSettingEnum.longColor.name,
      colorToString(tickerSetting.longColor),
    );
    _tickerSettingBox.put(
      BoxSettingEnum.shortColor.name,
      colorToString(tickerSetting.shortColor),
    );
    _tickerSettingBox.put(
      BoxSettingEnum.isBorderEnabled.name,
      tickerSetting.isBorderEnabled.toString(),
    );
    _tickerSettingBox.put(
      BoxSettingEnum.isPriceBackgroundAlarmEnabled.name,
      tickerSetting.isPriceBackgroundAlarmEnabled.toString(),
    );
    _tickerSettingBox.put(
      BoxSettingEnum.isQuoteUnitSignEnabled.name,
      tickerSetting.isQuoteUnitSignEnabled.toString(),
    );
    _tickerSettingBox.put(
      BoxSettingEnum.isPercentSignEnabled.name,
      tickerSetting.isPercentSignEnabled.toString(),
    );
    state = tickerSetting;
  }
}
