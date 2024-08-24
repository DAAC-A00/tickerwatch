// watch_main_screen.dart

import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';

class WatchMainScreen extends StatelessWidget {
  const WatchMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme currentTheme = Theme.of(context).colorScheme;

    // MediaQuery를 사용하여 화면 크기를 얻습니다.
    final screenSize = MediaQuery.of(context).size;

    // 화면의 width가 height보다 큰지 판단합니다.
    // -- landscape : 가로모드
    // -- portrait : 세로모드
    final bool isLandscape = screenSize.width > screenSize.height;
    final double minSideSize =
        isLandscape ? screenSize.height : screenSize.width;
    final tickerClickSize = minSideSize / 10;

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
      // 나가기 버튼 및 문구
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTickerWidget(
                  "60,240.16  +3.15%", tickerClickSize, true, true), // 좌측 상단
              _buildTickerWidget(
                  "60,240.16  +3.15%", tickerClickSize, true, false), // 우측 상단
            ],
          ),
          const Spacer(), // 중간 공간
          // 나가기 버튼
          isLandscape
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildExitButton(context),
                  ],
                )
              : const Spacer(),
          !isLandscape ? _buildExitButton(context) : const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTickerWidget(
                  "60,240.16  +3.15%", tickerClickSize, false, true), // 좌측 하단
              _buildTickerWidget(
                  "60,240.16  +3.15%", tickerClickSize, false, false), // 우측 하단
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildExitButton(BuildContext context) {
    final ColorScheme currentTheme = Theme.of(context).colorScheme;

    return RawMaterialButton(
      onPressed: () {
        Navigator.of(context).pop(); // 나가기 버튼의 기능
      },
      shape: const CircleBorder(),
      fillColor: Colors.transparent,
      elevation: 0, // 그림자 제거
      child: Icon(
        Icons.output,
        color: currentTheme.secondary,
      ),
    );
  }

  Widget _buildTickerWidget(
      String text, double tickerClickSize, bool isTop, bool isStart) {
    return Container(
      padding: isTop
          ? isStart
              ? EdgeInsets.only(
                  top: tickerClickSize,
                  bottom: tickerClickSize,
                  right: tickerClickSize)
              : EdgeInsets.only(
                  top: tickerClickSize,
                  bottom: tickerClickSize,
                  left: tickerClickSize)
          : isStart
              ? EdgeInsets.only(top: tickerClickSize, right: tickerClickSize)
              : EdgeInsets.only(top: tickerClickSize, left: tickerClickSize),
      child: Text(
        text,
      ),
    );
  }
}
