// action_test_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/actiontest/screens/custom_snack_bar_test_screen.dart';

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
            leading: const Icon(Icons.textsms),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: const Text('Custom SnackBar Test'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CustomSnackBarTestScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
