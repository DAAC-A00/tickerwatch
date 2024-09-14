// ticker_Alarm_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tickerwatch/product/default/db/box_enum.dart';
import 'package:tickerwatch/product/tickeralarm/entities/ticker_alarm_entity.dart';

final tickerAlarmProvider =
    StateNotifierProvider<TickerAlarmNotifier, List<TickerAlarmEntity>>((ref) {
  return TickerAlarmNotifier();
});

class TickerAlarmNotifier extends StateNotifier<List<TickerAlarmEntity>> {
  late Box<TickerAlarmEntity> _tickerAlarmEntityBox;

  TickerAlarmNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _tickerAlarmEntityBox =
        await Hive.openBox<TickerAlarmEntity>(BoxEnum.tickerAlarm.name);
    state = _tickerAlarmEntityBox.values.toList();
  }

  void insertBox(TickerAlarmEntity tickerAlarmEntity) {
    _tickerAlarmEntityBox.add(tickerAlarmEntity);
    state = _tickerAlarmEntityBox.values.toList();
  }

  void updateBox(int index, TickerAlarmEntity tickerAlarmEntity) {
    _tickerAlarmEntityBox.putAt(index, tickerAlarmEntity);
    state = _tickerAlarmEntityBox.values.toList();
  }

  void deleteBox(int index) {
    _tickerAlarmEntityBox.deleteAt(index);
    state = _tickerAlarmEntityBox.values.toList();
  }

  // 순서 변경 메소드 수정
  void updateOrderBox(int oldIndex, int newIndex) {
    // 이동할 TickerAlarmEntity를 가져옵니다.
    final movedTickerAlarm = _tickerAlarmEntityBox.getAt(oldIndex);
    if (movedTickerAlarm != null) {
      // 기존 위치에서 삭제
      _tickerAlarmEntityBox.deleteAt(oldIndex);
      if (newIndex > oldIndex) newIndex--;

      // newIndex부터 끝까지의 요소를 한 칸씩 뒤로 이동
      for (int i = _tickerAlarmEntityBox.length; i > newIndex; i--) {
        final tickerAlarm = _tickerAlarmEntityBox.getAt(i - 1);
        if (tickerAlarm != null) {
          if (i == _tickerAlarmEntityBox.length) {
            // 마지막 index에 있는 값 정정시, put이 아니라 add 진행
            _tickerAlarmEntityBox.add(tickerAlarm);
          } else {
            // 마지막이 아닌 index 값 정정시, put 진행
            _tickerAlarmEntityBox.putAt(i, tickerAlarm);
          }
        }
      }

      // 새로운 위치에 movedTickerAlarm 추가
      if (_tickerAlarmEntityBox.length == newIndex) {
        // 마지막 index에 붙이는 경우 add
        _tickerAlarmEntityBox.add(movedTickerAlarm);
      } else {
        // 마지막이 아닌 index에 넣는 경우 put
        _tickerAlarmEntityBox.putAt(newIndex, movedTickerAlarm);
      }
    }

    // 상태 업데이트
    state = _tickerAlarmEntityBox.values.toList(); // 상태 다시 설정
  }
}
