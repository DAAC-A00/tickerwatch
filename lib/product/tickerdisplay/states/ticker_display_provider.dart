// ticker_display_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tickerwatch/product/default/db/box_enum.dart';
import 'package:tickerwatch/product/tickerdisplay/entities/ticker_display_entity.dart';

final tickerDisplayProvider =
    StateNotifierProvider<TickerDisplayNotifier, List<TickerDisplayEntity>>(
        (ref) {
  return TickerDisplayNotifier();
});

class TickerDisplayNotifier extends StateNotifier<List<TickerDisplayEntity>> {
  late Box<TickerDisplayEntity> _tickerDisplayEntityBox;

  TickerDisplayNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _tickerDisplayEntityBox =
        await Hive.openBox<TickerDisplayEntity>(BoxEnum.tickerDisplay.name);
    state = _tickerDisplayEntityBox.values.toList();
  }

  void insertBox(TickerDisplayEntity tickerDisplayEntity) {
    _tickerDisplayEntityBox.add(tickerDisplayEntity);
    state = _tickerDisplayEntityBox.values.toList();
  }

  void updateBox(int index, TickerDisplayEntity tickerDisplayEntity) {
    _tickerDisplayEntityBox.putAt(index, tickerDisplayEntity);
    state = _tickerDisplayEntityBox.values.toList();
  }

  void deleteBox(int index) {
    _tickerDisplayEntityBox.deleteAt(index);
    state = _tickerDisplayEntityBox.values.toList();
  }
}
