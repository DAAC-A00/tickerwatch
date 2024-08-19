// watch_main_screen.dart

import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';

class WatchMainScreen extends StatelessWidget {
  const WatchMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme currentTheme = Theme.of(context).colorScheme;

    return Scaffold(
      // 내용
      body: Center(
        child: AnalogClock(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          // 시계 틀
          tickColor: currentTheme.primary, // 눈금 색상
          numberColor: currentTheme.primary, // 숫자 색상
          // 침
          showSecondHand: true, // 초침 표시 여부
          hourHandColor: currentTheme.primary, // 시침 색상
          minuteHandColor: currentTheme.primary, // 분침 색상
          secondHandColor: currentTheme.secondary, // 초침 색상
          // 디지털 시계
          showDigitalClock: true, // 활성화 여부
          digitalClockColor: Theme.of(context).hintColor, // 색
        ),
      ),
      // 나가기 버튼
      floatingActionButton: RawMaterialButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        shape: const CircleBorder(),
        fillColor: Colors.transparent,
        elevation: 0, // 그림자 제거
        child: Icon(
          Icons.output,
          color: currentTheme.secondary,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // 중앙 하단에 배치
    );
  }
}
