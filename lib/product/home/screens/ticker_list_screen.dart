// ticker_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/tickers/states/ticker_provider.dart';
import 'package:tickerwatch/product/tickers/enums/price_status_enum.dart';

class TickerListScreen extends ConsumerStatefulWidget {
  const TickerListScreen({super.key});

  @override
  ConsumerState<TickerListScreen> createState() => _TickerListScreenState();
}

class _TickerListScreenState extends ConsumerState<TickerListScreen> {
  final Map<int, Color> _borderColors = {}; // 각 ticker의 테두리 색을 저장할 맵

  @override
  Widget build(BuildContext context) {
    final tickers = ref.watch(tickerProvider);

    return Scaffold(
      body: tickers.isEmpty
          ? const Center(child: Text('등록된 ticker가 없습니다.'))
          : ListView.builder(
              itemCount: tickers.length,
              itemBuilder: (context, index) {
                final ticker = tickers[index];
                double currentPrice =
                    double.tryParse(ticker.recentData.price) ?? 0.0;
                double previousPrice =
                    double.tryParse(ticker.beforeData.price) ?? 0.0;

                // 가격 비교
                if (currentPrice != previousPrice) {
                  _borderColors[index] = currentPrice > previousPrice
                      ? Colors.green // 가격이 상승했을 때 초록색
                      : Colors.red; // 가격이 하락했을 때 빨간색

                  // 테두리 색상 초기화
                  Future.delayed(Duration(milliseconds: 200), () {
                    // 이 부분에서 setState를 호출하여 UI를 업데이트합니다.
                    if (mounted) {
                      setState(() {
                        _borderColors[index] = Colors.transparent; // 색상 초기화
                      });
                    }
                  });
                } else {
                  _borderColors[index] = Colors.transparent; // 가격이 동일할 경우
                }

                // changePercent24h 또는 changePercentUtc9 선택
                String changePercent =
                    ticker.recentData.changePercent24h.isNotEmpty
                        ? ticker.recentData.changePercent24h
                        : ticker.recentData.changePercentUtc9;

                // 글자 색상 설정
                Color textColor;
                switch (ticker.recentData.priceStatusEnum) {
                  case PriceStatusEnum.up:
                    textColor = Colors.green;
                    break;
                  case PriceStatusEnum.down:
                    textColor = Colors.red;
                    break;
                  case PriceStatusEnum.stay:
                  default:
                    textColor = Colors.grey;
                    break;
                }

                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ticker.info.symbol), // 심볼은 별도의 텍스트로 표시
                      // 가격과 변화율을 포함하는 AnimatedContainer
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _borderColors[index] ?? Colors.transparent,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ticker.recentData.price,
                                style: TextStyle(color: textColor),
                              ),
                            ),
                            SizedBox(width: 8), // 간격 추가
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                changePercent,
                                style: TextStyle(color: textColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
