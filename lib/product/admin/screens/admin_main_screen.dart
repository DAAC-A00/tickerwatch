// admin_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/actiontest/screens/action_test_main_screen.dart';
import 'package:tickerwatch/product/watch/screens/watch_main_screen.dart';
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
            leading: const Icon(Icons.data_thresholding_outlined),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: const Text('All Ticker Data'),
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
          ListTile(
            // 새로운 ListTile 추가
            leading: const Icon(Icons.biotech),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: const Text('Action Test Lab'),
            onTap: () {
              DeviceBackButtonHandler.disable();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ActionTestMainScreen(),
                ),
              ).then((_) {
                DeviceBackButtonHandler.enable();
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DeviceBackButtonHandler.disable();
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => const WatchMainScreen(),
            ),
          )
              .then((_) {
            DeviceBackButtonHandler.enable();
          });
        },
        tooltip: 'Go to New Screen',
        child: const Icon(Icons.watch_later_outlined),
      ),
    );
  }
}
