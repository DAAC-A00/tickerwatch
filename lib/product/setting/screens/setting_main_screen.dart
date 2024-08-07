// setting_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ticker_setting_screen.dart';
import 'exchange_setting_screen.dart';

class SettingMainScreen extends ConsumerStatefulWidget {
  const SettingMainScreen({super.key});

  @override
  ConsumerState<SettingMainScreen> createState() => _SettingMainScreenState();
}

class _SettingMainScreenState extends ConsumerState<SettingMainScreen> {
  @override
  Widget build(BuildContext context) {
    // final currentTheme = Theme.of(context).colorScheme;
    // final currentTextTheme = Theme.of(context).textTheme;
    // final settings = ref.watch(tickerSettingProvider);

    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.candlestick_chart),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: const Text('Ticker Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TickerSettingScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: const Text('Exchange Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExchangeSettingScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
