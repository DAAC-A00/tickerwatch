// ticker_setting_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/setting/entities/ticker_setting.dart';

import '../states/ticker_setting_provider.dart';
import '../widgets/change_percent_sample_widget.dart';
import '../widgets/price_sample_widget.dart';

class TickerSettingScreen extends ConsumerStatefulWidget {
  const TickerSettingScreen({super.key});

  @override
  ConsumerState<TickerSettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<TickerSettingScreen> {
  @override
  Widget build(BuildContext context) {
    final TickerSetting tickerSetting = ref.watch(tickerSettingProvider);
    final tickerSettingNotifier = ref.read(tickerSettingProvider.notifier);

    Widget buildRadioListTile({
      required String value,
      required String title,
    }) {
      return RadioListTile<String>(
        value: value,
        groupValue:
            '${colorToString(tickerSetting.upColor)}-${colorToString(tickerSetting.downColor)}',
        onChanged: (String? newValue) {
          tickerSettingNotifier.updateCandleColor(newValue ?? '');
        },
        title: Text(title),
      );
    }

    Widget buildSwitchListTile({
      required bool? value,
      required Function onChanged,
      required String title,
      required Widget subtitle,
    }) {
      return SwitchListTile(
        value: value ?? false,
        onChanged: (bool? newValue) {
          onChanged(newValue ?? false);
        },
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.normal),
        ),
        subtitle: subtitle,
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
                    sampleColor: tickerSetting.upColor,
                    sampleText: '+0.73%',
                    isPercentEnabled: true),
                const Spacer(),
                ChangePercentSampleWidget(
                    sampleIcon: Icons.arrow_drop_down,
                    sampleColor: tickerSetting.downColor,
                    sampleText: '-0.24%',
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
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: ListTile(
              title: PriceSampleWidget(
                sampleText: '\$ 60,000',
                color: tickerSetting.upColor,
                isQuoteUnitEnabled: tickerSetting.isQuoteUnitSignEnabled,
                isBorderEnabled: tickerSetting.isBorderEnabled,
              ),
              leading: const Icon(Icons.price_change),
            ),
          ),
          buildSwitchListTile(
            value: tickerSetting.isBorderEnabled,
            onChanged: (bool value) {
              tickerSettingNotifier.updateIsBorderEnabled(value);
            },
            title: '  Blink Border',
            subtitle: Text(
              tickerSetting.isBorderEnabled != null
                  ? tickerSetting.isBorderEnabled!
                      ? '  On'
                      : '  Off'
                  : '  Off',
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
          buildSwitchListTile(
            value: tickerSetting.isQuoteUnitSignEnabled,
            onChanged: (bool value) {
              tickerSettingNotifier.updateIsQuoteUnitSignEnabled(value);
            },
            title: '  Unit',
            subtitle: Text(
              tickerSetting.isQuoteUnitSignEnabled != null
                  ? tickerSetting.isQuoteUnitSignEnabled!
                      ? '  On'
                      : '  Off'
                  : '  Off',
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
