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

  // 순서 변경 메소드 수정
  void updateOrder(int oldIndex, int newIndex) {
    // 이동할 TickerDisplayEntity를 가져옵니다.
    final movedTickerDisplay = _tickerDisplayEntityBox.getAt(oldIndex);

    if (movedTickerDisplay != null) {
      // 기존 위치에서 삭제
      _tickerDisplayEntityBox.deleteAt(oldIndex);

      // newIndex부터 끝까지의 요소를 한 칸씩 뒤로 이동
      for (int i = _tickerDisplayEntityBox.length; i > newIndex; i--) {
        final tickerDisplay = _tickerDisplayEntityBox.getAt(i - 1);
        if (tickerDisplay != null) {
          if (i == _tickerDisplayEntityBox.length) {
            // 마지막 index에 있는 값 정정시, put이 아니라 add 진행
            _tickerDisplayEntityBox.add(tickerDisplay);
          } else {
            // 마지막이 아닌 index 값 정정시, put 진행
            _tickerDisplayEntityBox.putAt(i, tickerDisplay);
          }
        }
      }

      // 새로운 위치에 movedTickerDisplay 추가
      if (_tickerDisplayEntityBox.length == newIndex) {
        // 마지막 index에 붙이는 경우 add
        _tickerDisplayEntityBox.add(movedTickerDisplay);
      } else {
        // 마지막이 아닌 index에 넣는 경우 put
        _tickerDisplayEntityBox.putAt(newIndex, movedTickerDisplay);
      }
    }

    // 상태 업데이트
    state = _tickerDisplayEntityBox.values.toList(); // 상태 다시 설정
  }
}
