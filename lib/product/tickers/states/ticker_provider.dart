// ticker_provider.dart

import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tickerwatch/product/default/db/box_enum.dart';

import '../../../external/default/exchange_raw_category_enum.dart';
import '../entities/ticker_entity.dart';

final tickerProvider =
    StateNotifierProvider<TickerNotifier, List<TickerEntity>>((ref) {
  return TickerNotifier();
});

class TickerNotifier extends StateNotifier<List<TickerEntity>> {
  late Box<TickerEntity> _tickerBox;

  TickerNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _tickerBox = await Hive.openBox<TickerEntity>(BoxEnum.ticker.name);
    state = _tickerBox.values.toList();
  }

  void insertAllBox(List<TickerEntity> tickerList) {
    _tickerBox.addAll(tickerList);
    state = _tickerBox.values.toList();
  }

  void insertBox(TickerEntity ticker) {
    _tickerBox.add(ticker);
    state = _tickerBox.values.toList();
  }

  void updateBox(ExchangeRawCategoryEnum exchangeRawCategoryEnum,
      String rawSymbol, TickerEntity updatedTicker) {
    // 기존 데이터에서 업데이트할 항목을 찾기
    final index = state.indexWhere((ticker) =>
        ticker.info.exchangeRawCategoryEnum == exchangeRawCategoryEnum &&
        ticker.info.rawSymbol == rawSymbol);

    if (index != -1) {
      // 해당 인덱스가 존재하면 업데이트
      _tickerBox.putAt(index, updatedTicker);
      state = _tickerBox.values.toList();
    } else {
      // 업데이트할 항목이 없을 경우 필요한 로직 추가 가능
      log("Ticker not found for the given exchangeRawCategoryEnum and rawSymbol.");
    }
  }

  void deleteBox(int index) {
    _tickerBox.deleteAt(index);
    state = _tickerBox.values.toList();
  }
}
