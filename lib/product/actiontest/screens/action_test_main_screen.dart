// action_test_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/default/widgets/custom_snack_bar.dart';

class ActionTestMainScreen extends ConsumerStatefulWidget {
  const ActionTestMainScreen({super.key});

  @override
  ConsumerState<ActionTestMainScreen> createState() =>
      _ActionTestMainScreenState();
}

class _ActionTestMainScreenState extends ConsumerState<ActionTestMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Test Screen'),
      ),
      body: ListView(
        children: [
          ListTile(
            trailing: const Icon(Icons.textsms),
            title: const Text(' Custom SnackBar 띄우기'),
            onTap: () {
              showCustomSnackBar(context, '🎉 완료', '값 변경 안내의 정보성 메시지를 주로 담아요');
            },
          ),
        ],
      ),
    );
  }
}
