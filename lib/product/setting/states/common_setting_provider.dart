// common_setting_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../default/db/box_enum.enum.dart';
import '../../default/db/setting_box_key_enum.dart';
import '../entities/common_setting.dart';

final commonSettingProvider =
    StateNotifierProvider<CommonSettingNotifier, CommonSetting>((ref) {
  return CommonSettingNotifier();
});

final CommonSetting defaultCommonSetting = CommonSetting(
  isLightMode: false, // true면 기본값이 Dark Mode, false면 기본값이 Light Mode
);

class CommonSettingNotifier extends StateNotifier<CommonSetting> {
  late Box<String> _commonSettingBox;

  CommonSettingNotifier() : super(defaultCommonSetting) {
    _init();
  }

  Future<void> _init() async {
    _commonSettingBox = await Hive.openBox<String>(BoxEnum.setting.name);
    final bool isLightMode = _commonSettingBox.get(
          SettingBoxKeyEnum.isLightMode.name,
          defaultValue: defaultCommonSetting.isLightMode.toString(),
        )! ==
        'true';

    state = CommonSetting(isLightMode: isLightMode);
  }

  void updateBox(CommonSetting commonSetting) {
    _commonSettingBox.put(SettingBoxKeyEnum.isLightMode.name,
        commonSetting.isLightMode.toString());
    state = commonSetting;
  }
}
