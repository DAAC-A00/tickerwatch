// watch_main_screen.dart

import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';

class WatchMainScreen extends StatelessWidget {
  const WatchMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme currentTheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: AnalogClock(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          showSecondHand: true, // 초침 표시 여부
          hourHandColor: currentTheme.primary, // 시침 색상
          minuteHandColor: currentTheme.primary, // 분침 색상
          secondHandColor: currentTheme.secondary, // 초침 색상
          tickColor: currentTheme.primary, // 눈금 색상
          numberColor: currentTheme.primary, // 숫자 색상
          showDigitalClock: true, // 디지털 시계 활성화 여부
          digitalClockColor: currentTheme.secondary,
        ),
      ),
      floatingActionButton: RawMaterialButton(
        onPressed: () {
          Navigator.of(context).pop(); // 뒤로가기
        },
        shape: const CircleBorder(), // 원형으로 설정
        fillColor: Colors.transparent, // 배경색 투명으로 설정
        elevation: 0, // 그림자 제거
        child: Icon(
          Icons.arrow_back,
          color: currentTheme.secondary, // 아이콘 색상을 텍스트 색상과 동일하게 설정
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // 중앙 하단에 배치
    );
  }
}
