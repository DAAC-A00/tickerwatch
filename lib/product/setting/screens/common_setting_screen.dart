// common_setting_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/common_setting_provider.dart';

class CommonSettingScreen extends ConsumerWidget {
  const CommonSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commonSetting = ref.watch(commonSettingProvider);
    final commonSettingNotifier = ref.read(commonSettingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('앱설정'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('테마 설정'),
            subtitle: Text(
              commonSetting.isLightMode ? '☀️ Light' : '🌑 Dark',
            ),
            value: commonSetting.isLightMode,
            onChanged: (bool value) {
              commonSettingNotifier.updateIsLightModeBox(value);
            },
          ),
          SwitchListTile(
            title: const Text('개발자 모드'),
            subtitle: Text(
              commonSetting.isDevMode ? '👩🏻‍💻 On' : '👩🏻‍💼 Off',
            ),
            value: commonSetting.isDevMode,
            onChanged: (bool value) {
              commonSettingNotifier.updateIsDevModeBox(value);
            },
          ),
          SwitchListTile(
            title: const Text('슈퍼 모드'),
            subtitle: Text(
              commonSetting.isSuperMode ? '🌈 On' : '☁️ Off',
            ),
            value: commonSetting.isSuperMode,
            onChanged: (bool value) {
              commonSettingNotifier.updateIsSuperModeBox(value);
            },
          ),
        ],
      ),
    );
  }
}
