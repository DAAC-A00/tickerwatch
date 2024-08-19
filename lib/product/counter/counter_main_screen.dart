// home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'counter_provider.dart';

class CounterMainScreen extends ConsumerStatefulWidget {
  const CounterMainScreen({super.key});

  @override
  ConsumerState<CounterMainScreen> createState() => _CounterMainScreenState();
}

class _CounterMainScreenState extends ConsumerState<CounterMainScreen> {
  @override
  Widget build(BuildContext context) {
    final counter = ref.watch(counterProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // 상태 값을 변경
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
