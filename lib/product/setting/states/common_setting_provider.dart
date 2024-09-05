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
  isLightMode: false,
  isAdminMode: false,
  isSuperMode: false,
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
    final bool isAdminMode = _commonSettingBox.get(
          BoxSettingEnum.isAdminMode.name,
          defaultValue: defaultCommonSetting.isAdminMode.toString(),
        )! ==
        'true';
    final bool isSuperMode = _commonSettingBox.get(
          BoxSettingEnum.isSuperMode.name,
          defaultValue: defaultCommonSetting.isSuperMode.toString(),
        )! ==
        'true';

    state = CommonSetting(
      isLightMode: isLightMode,
      isAdminMode: isAdminMode,
      isSuperMode: isSuperMode,
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
    state = CommonSetting(
        isLightMode: isLightMode,
        isAdminMode: state.isAdminMode,
        isSuperMode: state.isSuperMode);
  }

  void updateIsAdminModeBox(bool isAdminMode) {
    _commonSettingBox.put(
        BoxSettingEnum.isAdminMode.name, isAdminMode.toString());
    state = CommonSetting(
        isLightMode: state.isLightMode,
        isAdminMode: isAdminMode,
        isSuperMode: state.isSuperMode);
  }

  void updateIsSuperModeBox(bool isSuperMode) {
    _commonSettingBox.put(
        BoxSettingEnum.isSuperMode.name, isSuperMode.toString());
    state = CommonSetting(
        isLightMode: state.isLightMode,
        isAdminMode: state.isAdminMode,
        isSuperMode: isSuperMode);
  }
}
