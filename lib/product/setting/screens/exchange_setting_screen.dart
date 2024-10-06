// exchange_setting_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/setting/states/common_setting_provider.dart';
import 'package:tickerwatch/product/tickers/enums/category_exchange_enum.dart';
import 'bybit_exchange_setting_screen.dart';

class ExchangeSettingScreen extends ConsumerStatefulWidget {
  const ExchangeSettingScreen({super.key});

  @override
  ConsumerState<ExchangeSettingScreen> createState() =>
      _ExchangeSettingScreenState();
}

class _ExchangeSettingScreenState extends ConsumerState<ExchangeSettingScreen> {
  @override
  Widget build(BuildContext context) {
    final currentTextTheme = Theme.of(context).textTheme;
    final commonSetting = ref.watch(commonSettingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('거래소 설정'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading:
                commonSetting.isLightMode ? const Text('⚪') : const Text('⚫'),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: Row(
              children: [
                SizedBox(
                  height: currentTextTheme.titleMedium?.fontSize,
                  child: CategoryExchangeEnum.spotBybit.logoImage,
                ),
                const Text(' Bybit Key 설정'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BybitExchangeSettingScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
