// watch_main_screen.dart

import 'package:flutter/material.dart';

class WatchMainScreen extends StatelessWidget {
  const WatchMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'This is the Watch Screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(); // 뒤로가기
        },
        tooltip: 'Back',
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // 중앙 하단에 배치
    );
  }
}
