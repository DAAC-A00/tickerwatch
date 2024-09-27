// home_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/default/widgets/custom_snack_bar.dart';

import '../../default/handler/device_back_button_handler.dart';
import '../../watch/screens/watch_main_screen.dart';

class HomeMainScreen extends ConsumerStatefulWidget {
  const HomeMainScreen({super.key});

  @override
  ConsumerState<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends ConsumerState<HomeMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Text(
              'Welcome to the Home Screen!',
            ),
            ElevatedButton(
                onPressed: () => showCustomSnackBar(
                    context, '🇰🇷 대한민국 만세', ' 이얏호 테스트 으쌰으쌰~'),
                child: const Text('snackbar test')),
          ],
        ),
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
