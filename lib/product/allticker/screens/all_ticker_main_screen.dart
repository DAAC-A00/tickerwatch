// all_ticker_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/allticker/screens/all_ticker_detail_screen.dart';
import 'package:tickerwatch/product/default/widgets/custom_modal_bottom_sheet.dart';
import 'package:tickerwatch/product/setting/states/ticker_setting_provider.dart';

import '../../tickers/states/ticker_provider.dart';

class AllTickerMainScreen extends ConsumerStatefulWidget {
  const AllTickerMainScreen({super.key});

  @override
  ConsumerState<AllTickerMainScreen> createState() =>
      _AllTickerMainScreenState();
}

class _AllTickerMainScreenState extends ConsumerState<AllTickerMainScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> contentList = [
    '개요',
    '현재 디바이스에 저장된 모든 ticker 정보를 조회하고 검색할 수 있는 화면입니다.',
    '주의사항',
    '현재는 bybit spot 정보만 수집 및 저장하고 있습니다.',
    '기능 추가 예정 내용',
    'binance, okx 등 거래소가 추가될 예정이며 spot 외에 cm(coin-margined), um(usdS-margined) 등의 정보 수집 및 저장 또한 추가될 예정입니다.',
    '슈퍼 모드 활성화 여부에 따른 차이점',
    '슈퍼 모드 활성화시 bybit spot의 모든 정보를 실시간으로 업데이트합니다.\n단, 슈퍼 모드 비활성화시 앱 실행했을때에만 정보를 수집해 저장하고 이후 실시간으로 최신회된 정보로 업데이트되지는 않습니다.'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tickerSetting = ref.watch(tickerSettingProvider);
    final Color? upColor = tickerSetting.upColor;
    final Color? downColor = tickerSetting.downColor;
    final Color transparentColor = Colors.transparent;
    final tickers = ref.watch(tickerProvider);

    // 검색된 ticker 리스트
    final filteredTickers = tickers.where((ticker) {
      return ticker.info.searchKeywords
          .toLowerCase()
          .contains(_searchController.text.replaceAll(' ', '').toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: '검색',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text != ''
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear(); // 컨트롤러를 통해 입력값을 지웁니다.
                      setState(() {}); // 상태를 갱신하여 필터링
                    },
                  )
                : null,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () =>
                showCustomModalBottomSheet(context, 'ℹ️ 유의사항', contentList),
          ),
        ],
      ),
      body: filteredTickers.isEmpty
          ? const Center(
              child: Text('검색 결과가 없습니다。'),
            )
          : ListView.builder(
              itemCount: filteredTickers.length,
              itemBuilder: (context, index) {
                final ticker = filteredTickers[index];
                double currentPrice =
                    double.tryParse(ticker.recentData.price) ?? 0.0;
                double previousPrice =
                    double.tryParse(ticker.beforeData.price) ?? 0.0;

                // 테두리 색상 결정
                Color borderColor = transparentColor;
                if (currentPrice > previousPrice) {
                  borderColor = upColor ?? transparentColor; // 가격 상승
                } else if (currentPrice < previousPrice) {
                  borderColor = downColor ?? transparentColor; // 가격 하락
                } else {
                  borderColor = transparentColor; // 가격 동일
                }

                // changePercent 결정 및 글자 색상 설정
                String changePercent =
                    ticker.recentData.changePercent24h.isNotEmpty
                        ? ticker.recentData.changePercent24h
                        : ticker.recentData.changePercentUtc9;
                Color? textColor;
                double changeValue = double.tryParse(changePercent) ?? 0.0;

                if (changeValue > 0) {
                  textColor = upColor; // 양수일 경우 초록색
                } else if (changeValue < 0) {
                  textColor = downColor; // 음수일 경우 빨간색
                } else {
                  textColor = Colors.grey; // 0.00일 경우 회색
                }

                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ticker.info.symbol),
                      // 가격과 변화율을 포함하는 AnimatedContainer
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: borderColor,
                            width: 2,
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
                  onTap: () {
                    // ListTile 클릭 시 AllTickerDetailScreen으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllTickerDetailScreen(ticker: ticker),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
