// common_setting_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../default/db/box_enum.dart';
import '../../default/db/box_setting_enum.dart';
import '../entities/common_setting.dart';

final commonSettingProvider =
    StateNotifierProvider<CommonSettingNotifier, CommonSetting>((ref) {
  return CommonSettingNotifier();
});

final CommonSetting defaultCommonSetting = CommonSetting(
  isLightMode: false, // true면 기본값이 Dark Mode, false면 기본값이 Light Mode
  isDevMode: false,
);

class CommonSettingNotifier extends StateNotifier<CommonSetting> {
  late Box<String> _commonSettingBox;

  CommonSettingNotifier() : super(defaultCommonSetting) {
    _init();
  }

  Future<void> _init() async {
    _commonSettingBox = await Hive.openBox<String>(BoxEnum.setting.name);
    final bool isLightMode = _commonSettingBox.get(
          BoxSettingEnum.isLightMode.name,
          defaultValue: defaultCommonSetting.isLightMode.toString(),
        )! ==
        'true';
    final bool isDevMode = _commonSettingBox.get(
          BoxSettingEnum.isDevMode.name,
          defaultValue: defaultCommonSetting.isLightMode.toString(),
        )! ==
        'true';

    state = CommonSetting(
      isLightMode: isLightMode,
      isDevMode: isDevMode,
    );
  }

  void updateBox(CommonSetting commonSetting) {
    _commonSettingBox.put(
        BoxSettingEnum.isLightMode.name, commonSetting.isLightMode.toString());
    state = commonSetting;
  }

  void updateIsLightModeBox(bool isLightMode) {
    _commonSettingBox.put(
        BoxSettingEnum.isLightMode.name, isLightMode.toString());
    state = CommonSetting(isLightMode: isLightMode, isDevMode: state.isDevMode);
  }

  void updateIsDevModeBox(bool isDevMode) {
    _commonSettingBox.put(BoxSettingEnum.isDevMode.name, isDevMode.toString());
    state = CommonSetting(isLightMode: state.isLightMode, isDevMode: isDevMode);
  }
}
