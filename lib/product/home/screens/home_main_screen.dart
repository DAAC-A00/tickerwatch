// home_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the Home Screen!',
            ),
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
