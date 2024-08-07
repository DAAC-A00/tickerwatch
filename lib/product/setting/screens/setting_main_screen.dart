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
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TickerSettingScreen()),
                );
              },
              child: const Text('Ticker Settings'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ExchangeSettingScreen()),
                );
              },
              child: const Text('Exchange Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
