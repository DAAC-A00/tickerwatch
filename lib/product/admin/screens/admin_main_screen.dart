// admin_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../allticker/screens/all_ticker_main_screen.dart';
import '../../default/handler/device_back_button_handler.dart';

class AdminMainScreen extends ConsumerStatefulWidget {
  const AdminMainScreen({super.key});

  @override
  ConsumerState<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends ConsumerState<AdminMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.density_small),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: const Text(
              '전체 Ticker 정보 조회',
            ),
            onTap: () {
              DeviceBackButtonHandler.disable();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllTickerMainScreen(),
                ),
              ).then((_) {
                DeviceBackButtonHandler.enable();
              });
            },
          ),
        ],
      ),
    );
  }
}
