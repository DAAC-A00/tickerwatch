// ticker_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tickerwatch/product/default/db/box_enum.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_model.dart';

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

  void updateAllBox(List<TickerEntity> updatedTickerList) {
    for (var updatedTicker in updatedTickerList) {
      final index = state.indexWhere((ticker) =>
          ticker.info.exchangeRawCategoryEnum ==
              updatedTicker.info.exchangeRawCategoryEnum &&
          ticker.info.rawSymbol == updatedTicker.info.rawSymbol);

      if (index != -1) {
        // 기존에 저장된 recentData는 beforeData로 이동
        updatedTicker.beforeData = _tickerBox.getAt(index)?.recentData ??
            TickerModel(
                price:
                    ''); // recentData 업데이트 전에, 기존의 recentData를 beforeData로 복사

        // 해당 인덱스가 있으면 수정
        if (updatedTicker.recentData.price == updatedTicker.beforeData.price) {
          // 가격 변동이 없으면 false 상태 유지
          updatedTicker.recentData.isUpdatedRecently = false;
        } else {
          // 가격 변동이 있으면 true로 변경
          updatedTicker.recentData.isUpdatedRecently = true;
        }

        _tickerBox.putAt(index, updatedTicker); // recentDat 수정 적용
        // 0.2초 후에 isUpdatedRecently를 false로 설정
        Future.delayed(Duration(milliseconds: 200), () {
          updatedTicker.recentData.isUpdatedRecently = false;
          _tickerBox.putAt(index, updatedTicker); // 상태 업데이트
        });
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
