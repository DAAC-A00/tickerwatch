// bybit_exchange_setting_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/default/widgets/custom_snack_bar.dart';
import 'package:tickerwatch/product/setting/states/exchange_setting_provider.dart';

class BybitExchangeSettingScreen extends ConsumerWidget {
  const BybitExchangeSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exchangeSetting = ref.watch(exchangeSettingProvider);

    final TextEditingController apiKeyController =
        TextEditingController(text: exchangeSetting.bybitApiKey);
    final TextEditingController secretKeyController =
        TextEditingController(text: exchangeSetting.bybitSecretKey);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bybit Key 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: apiKeyController,
              decoration: const InputDecoration(
                labelText: 'Bybit API Key',
              ),
            ),
            TextField(
              controller: secretKeyController,
              decoration: const InputDecoration(
                labelText: 'Bybit Secret Key',
              ),
              obscureText: true, // 비밀번호 입력 시 보안
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(exchangeSettingProvider.notifier)
                    .updateBybitApiKeyBox(apiKeyController.text);
                ref
                    .read(exchangeSettingProvider.notifier)
                    .updateBybitSecretKeyBox(secretKeyController.text);
                showCustomSnackBar(context, '✅ Key 저장 완료', '설정이 저장되었습니다.');
              },
              child: const Text('저장'),
            ),
            const SizedBox(height: 20),
            Text(
              '현재 API Key: ${exchangeSetting.bybitApiKey ?? '없음'}',
            ),
            Text(
              '현재 Secret Key: ${exchangeSetting.bybitSecretKey ?? '없음'}',
            ),
          ],
        ),
      ),
    );
  }
}
