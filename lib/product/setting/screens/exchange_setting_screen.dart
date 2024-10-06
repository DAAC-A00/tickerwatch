// exchange_setting_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    // final currentTheme = Theme.of(context).colorScheme;
    // final currentTextTheme = Theme.of(context).textTheme;
    // final settings = ref.watch(tickerSettingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('거래소 설정'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.looks_one),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: const Text(
              'Bybit Key 설정',
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
