// exchange_setting_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:tickerwatch/product/setting/entities/exchange_setting.dart';
import '../../default/db/box_enum.dart';
import '../../default/db/box_setting_enum.dart';

final exchangeSettingProvider =
    StateNotifierProvider<ExchangeSettingNotifier, ExchangeSetting>((ref) {
  return ExchangeSettingNotifier();
});

final ExchangeSetting defaultExchangeSetting = ExchangeSetting(
  bybitApiKey: null,
  bybitSecretKey: null,
);

class ExchangeSettingNotifier extends StateNotifier<ExchangeSetting> {
  late Box<String> _exchangeSettingBox;

  ExchangeSettingNotifier() : super(defaultExchangeSetting) {
    _init();
  }

  Future<void> _init() async {
    _exchangeSettingBox = await Hive.openBox<String>(BoxEnum.setting.name);

    final String? bybitApiKey = _exchangeSettingBox.get(
      BoxSettingEnum.bybitApiKey.name,
      defaultValue: defaultExchangeSetting.bybitApiKey ?? '',
    );
    final String? bybitSecretKey = _exchangeSettingBox.get(
      BoxSettingEnum.bybitSecretKey.name,
      defaultValue: defaultExchangeSetting.bybitSecretKey ?? '',
    );

    state = ExchangeSetting(
      bybitApiKey: bybitApiKey,
      bybitSecretKey: bybitSecretKey,
    );
  }

  void updateBybitApiKeyBox(String? apiKey) {
    _exchangeSettingBox.put(BoxSettingEnum.bybitApiKey.name, apiKey ?? '');
    state = state.copyWith(bybitApiKey: apiKey);
  }

  void updateBybitSecretKeyBox(String? secretKey) {
    _exchangeSettingBox.put(
        BoxSettingEnum.bybitSecretKey.name, secretKey ?? '');
    state = state.copyWith(bybitSecretKey: secretKey);
  }
}
