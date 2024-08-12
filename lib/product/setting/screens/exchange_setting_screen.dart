// exchange_setting_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExchangeSettingScreen extends ConsumerWidget {
  const ExchangeSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange Settings'),
      ),
      body: const Center(
        child: Column(
          children: [
            Text(
              '상세 페이지 적용O',
            ),
            Text(
              '상세 페이지 적용X',
            ),
          ],
        ),
      ),
    );
  }
}
