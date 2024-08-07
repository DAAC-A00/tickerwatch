// ticker_setting_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TickerSettingScreen extends ConsumerWidget {
  const TickerSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticker Settings'),
      ),
      body: const Center(
        child: Text('Ticker Settings Detail'),
      ),
    );
  }
}
