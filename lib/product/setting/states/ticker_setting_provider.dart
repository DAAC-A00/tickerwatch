// ticker_setting_provider.dart

import 'dart:developer';

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
  upColor: null,
  downColor: null,
  isBorderEnabled: null,
  borderBlinkMilliseconds: null,
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
    final String upColorString = _tickerSettingBox.get(
      BoxSettingEnum.upColor.name,
      defaultValue: colorToString(defaultTickerSetting.upColor ?? Colors.red),
    )!;
    final String downColorString = _tickerSettingBox.get(
      BoxSettingEnum.downColor.name,
      defaultValue:
          colorToString(defaultTickerSetting.downColor ?? Colors.blue),
    )!;
    final bool isBorderEnabled = _tickerSettingBox.get(
          BoxSettingEnum.isBorderEnabled.name,
          defaultValue:
              (defaultTickerSetting.isBorderEnabled ?? true).toString(),
        )! ==
        true.toString();
    final int? borderBlinkMilliseconds = int.tryParse(_tickerSettingBox.get(
      BoxSettingEnum.borderBlinkMilliseconds.name,
      defaultValue:
          (defaultTickerSetting.borderBlinkMilliseconds ?? 200).toString(),
    )!);
    final bool isPriceBackgroundAlarmEnabled = _tickerSettingBox.get(
          BoxSettingEnum.isPriceBackgroundAlarmEnabled.name,
          defaultValue:
              (defaultTickerSetting.isPriceBackgroundAlarmEnabled ?? true)
                  .toString(),
        )! ==
        true.toString();
    final bool isQuoteUnitSignEnabled = _tickerSettingBox.get(
          BoxSettingEnum.isQuoteUnitSignEnabled.name,
          defaultValue:
              (defaultTickerSetting.isQuoteUnitSignEnabled ?? false).toString(),
        )! ==
        true.toString();
    final bool isPercentSignEnabled = _tickerSettingBox.get(
          BoxSettingEnum.isPercentSignEnabled.name,
          defaultValue:
              (defaultTickerSetting.isPercentSignEnabled ?? true).toString(),
        )! ==
        true.toString();

    state = TickerSetting(
      upColor: _stringToColor(upColorString, isLightMode),
      downColor: _stringToColor(downColorString, isLightMode),
      isBorderEnabled: isBorderEnabled,
      borderBlinkMilliseconds: borderBlinkMilliseconds,
      isPriceBackgroundAlarmEnabled: isPriceBackgroundAlarmEnabled,
      isQuoteUnitSignEnabled: isQuoteUnitSignEnabled,
      isPercentSignEnabled: isPercentSignEnabled,
    );
  }

  void updateCandleColor(String newColor) {
    String? upColorString = newColor.split('-').firstOrNull;
    String? downColorString = newColor.split('-').lastOrNull;
    if (upColorString != null && downColorString != null) {
      _tickerSettingBox.put(BoxSettingEnum.upColor.name, upColorString);
      _tickerSettingBox.put(BoxSettingEnum.downColor.name, downColorString);
      state = state.copyWith(
        upColor: _stringToColor(upColorString, isLightMode),
        downColor: _stringToColor(downColorString, isLightMode),
      );
    } else {
      log('[WARN][TickerSettingNotifier.updateCandleColor] upColorString or downColorString is null. So BoxSetting not updated.');
    }
  }

  void updateIsQuoteUnitSignEnabled(bool isEnable) {
    _tickerSettingBox.put(
        BoxSettingEnum.isQuoteUnitSignEnabled.name, isEnable.toString());
    state = state.copyWith(
      isQuoteUnitSignEnabled: isEnable,
    );
  }

  void updateIsBorderEnabled(bool isEnable) {
    _tickerSettingBox.put(
        BoxSettingEnum.isBorderEnabled.name, isEnable.toString());
    state = state.copyWith(
      isBorderEnabled: isEnable,
    );
  }

  void updateBorderBlinkMilliseconds(int? milliseconds) {
    final newMilliseconds = milliseconds ?? 200;
    _tickerSettingBox.put(BoxSettingEnum.borderBlinkMilliseconds.name,
        newMilliseconds.toString());
    state = state.copyWith(borderBlinkMilliseconds: newMilliseconds);
  }

  void updateIsPercentSignEnabled(bool isEnable) {
    _tickerSettingBox.put(
        BoxSettingEnum.isPercentSignEnabled.name, isEnable.toString());
    state = state.copyWith(
      isPercentSignEnabled: isEnable,
    );
  }

  void updateBox(TickerSetting tickerSetting) {
    _tickerSettingBox.put(
      BoxSettingEnum.upColor.name,
      colorToString(tickerSetting.upColor),
    );
    _tickerSettingBox.put(
      BoxSettingEnum.downColor.name,
      colorToString(tickerSetting.downColor),
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
