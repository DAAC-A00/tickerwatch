// counter_provider.dart

// StateProvider를 사용하여 상태 관리
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:tickerwatch/product/default/db/box_enum.dart';

final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int> {
  late Box<int> box;
  CounterNotifier() : super(0) {
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    box = await Hive.openBox<int>(BoxEnum.counter.name);
    state = box.get('counter', defaultValue: 0)!;
  }

  Future<void> increment() async {
    state++;
    box = await Hive.openBox<int>(BoxEnum.counter.name);
    await box.put('counter', state);
  }
}
