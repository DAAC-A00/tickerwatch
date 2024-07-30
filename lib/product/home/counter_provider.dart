// counter_provider.dart

// StateProvider를 사용하여 상태 관리
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0) {
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final box = await Hive.openBox<int>('counterBox');
    state = box.get('counter', defaultValue: 0)!;
  }

  Future<void> increment() async {
    state++;
    final box = await Hive.openBox<int>('counterBox');
    await box.put('counter', state);
  }
}
