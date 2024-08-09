// ticker_setting_screen.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/ticker_setting_provider.dart';
import '../widgets/change_percent_sample_widget.dart';

class TickerSettingScreen extends ConsumerStatefulWidget {
  const TickerSettingScreen({super.key});

  @override
  ConsumerState<TickerSettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<TickerSettingScreen> {
  @override
  Widget build(BuildContext context) {
    final tickerSetting = ref.watch(tickerSettingProvider);
    final tickerSettingNotifier = ref.read(tickerSettingProvider.notifier);

    log('${colorToString(tickerSetting.longColor)}-${colorToString(tickerSetting.shortColor)}');

    Widget buildRadioListTile({
      required String value,
      required String title,
    }) {
      return RadioListTile<String>(
        value: value,
        groupValue:
            '${colorToString(tickerSetting.longColor)}-${colorToString(tickerSetting.shortColor)}',
        onChanged: (String? newValue) {
          tickerSettingNotifier.updateCandleColor(newValue ?? '');
        },
        title: Text(title),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('가격 표기 설정')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Row(
              children: [
                const Text('색'),
                const Spacer(),
                const Spacer(),
                const Spacer(),
                const Spacer(),
                const Spacer(),
                ChangePercentSampleWidget(
                    sampleIcon: Icons.arrow_drop_up,
                    sampleColor: tickerSetting.longColor,
                    sampleText: '+0.78%',
                    isPercentEnabled: true),
                const Spacer(),
                ChangePercentSampleWidget(
                    sampleIcon: Icons.arrow_drop_down,
                    sampleColor: tickerSetting.shortColor,
                    sampleText: '-0.31%',
                    isPercentEnabled: true)
              ],
            ),
            leading: const Icon(Icons.color_lens),
          ),
          buildRadioListTile(
            value: 'red-blue',
            title: 'Korea',
          ),
          buildRadioListTile(
            value: 'green-red',
            title: 'Global',
          ),
          buildRadioListTile(
            value: 'primary-primary',
            title: 'Normal',
          ),
          buildRadioListTile(
            value: 'grey-grey',
            title: 'Grey',
          ),
          // 다른 설정 항목들 추가 가능
        ],
      ),
    );
  }
}
