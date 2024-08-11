// common_setting_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/common_setting.dart';
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
            title: const Text('Dark Mode'),
            value: commonSetting.isDarkMode,
            onChanged: (bool value) {
              commonSettingNotifier.updateBox(
                CommonSetting(isDarkMode: value),
              );
            },
          ),
        ],
      ),
    );
  }
}
