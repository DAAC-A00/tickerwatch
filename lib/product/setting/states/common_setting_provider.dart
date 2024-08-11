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
  isDarkMode: true,
);

class CommonSettingNotifier extends StateNotifier<CommonSetting> {
  late Box<String> _CommonSettingBox;

  CommonSettingNotifier() : super(defaultCommonSetting) {
    _init();
  }

  Future<void> _init() async {
    _CommonSettingBox = await Hive.openBox<String>(BoxEnum.setting.name);
    final bool isDarkMode = _CommonSettingBox.get(
          SettingBoxKeyEnum.isDarkMode.name,
          defaultValue: defaultCommonSetting.isDarkMode.toString(),
        )! ==
        'true';

    state = CommonSetting(isDarkMode: isDarkMode);
  }

  void updateBox(CommonSetting commonSetting) {
    _CommonSettingBox.put(
        SettingBoxKeyEnum.isDarkMode.name, commonSetting.isDarkMode.toString());
    state = commonSetting;
  }
}
