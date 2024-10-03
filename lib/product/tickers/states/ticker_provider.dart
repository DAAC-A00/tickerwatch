// ticker_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tickerwatch/product/default/db/box_enum.dart';

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

  void insertBox(TickerEntity ticker) {
    _tickerBox.add(ticker);
    state = _tickerBox.values.toList();
  }

  void insertAllBox(List<TickerEntity> tickerList) {
    _tickerBox.addAll(tickerList);
    state = _tickerBox.values.toList();
  }

  void updateBox(TickerEntity updatedTicker) {
    // 기존 데이터에서 업데이트할 항목을 찾기
    final index = state.indexWhere((ticker) =>
        ticker.info.exchangeRawCategoryEnum ==
            updatedTicker.info.exchangeRawCategoryEnum &&
        ticker.info.rawSymbol == updatedTicker.info.rawSymbol);

    if (index != -1) {
      // 해당 인덱스가 있으면 수정
      _tickerBox.putAt(index, updatedTicker);
    } else {
      // 없으면 추가
      _tickerBox.add(updatedTicker);
    }
    state = _tickerBox.values.toList();
  }

  void updateAllBox(List<TickerEntity> updatedTickerList) {
    for (var updatedTicker in updatedTickerList) {
      final index = state.indexWhere((ticker) =>
          ticker.info.exchangeRawCategoryEnum ==
              updatedTicker.info.exchangeRawCategoryEnum &&
          ticker.info.rawSymbol == updatedTicker.info.rawSymbol);

      if (index != -1) {
        // 해당 인덱스가 있으면 수정
        updatedTicker.beforeData = _tickerBox
            .getAt(index)
            ?.recentData; // recentData 업데이트 전에, 기존의 recentData를 beforeData로 복사
        _tickerBox.putAt(index, updatedTicker); // recentDat와 beforeData 수정 적용
      } else {
        // 없으면 추가
        _tickerBox.add(updatedTicker);
      }
    }
    // 상태 갱신
    state = _tickerBox.values.toList();
  }

  void deleteBox(int index) {
    _tickerBox.deleteAt(index);
    state = _tickerBox.values.toList();
  }
}
