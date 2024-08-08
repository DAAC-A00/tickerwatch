// ticker_setting_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ticker_setting_provider.dart';

class TickerSettingScreen extends ConsumerStatefulWidget {
  const TickerSettingScreen({super.key});

  @override
  ConsumerState<TickerSettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<TickerSettingScreen> {
  @override
  Widget build(BuildContext context) {
    final tickerSetting = ref.watch(tickerSettingProvider);

    Widget buildRadioListTile({
      required String value,
      required String title,
    }) {
      return RadioListTile<String>(
        value: value,
        groupValue: tickerSetting.candleColor,
        onChanged: (String? newValue) {
          ref
              .read(tickerSettingProvider.notifier)
              .updateCandleColor(newValue ?? 'red-blue');
        },
        title: Text(title),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticker Settings'),
      ),
      body: ListView(
        children: <Widget>[
          const ListTile(
            title: Text('Candle Color'),
            leading: Icon(Icons.color_lens),
          ),
          buildRadioListTile(
            value: 'red-blue',
            title: 'Red-Blue',
          ),
          buildRadioListTile(
            value: 'green-red',
            title: 'Green-Red',
          ),
          buildRadioListTile(
            value: 'normal',
            title: 'Normal',
          ),
          buildRadioListTile(
            value: 'hidden',
            title: 'Hidden',
          ),
          // 다른 설정 항목들 추가 가능
        ],
      ),
    );
  }
}
