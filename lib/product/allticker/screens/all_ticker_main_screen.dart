// all_ticker_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/allticker/screens/all_ticker_detail_screen.dart';
import 'package:tickerwatch/product/default/widgets/custom_modal_bottom_sheet.dart';
import 'package:tickerwatch/product/setting/states/ticker_setting_provider.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_entity.dart';
import 'package:tickerwatch/product/tickers/enums/price_status_enum.dart';

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
    // theme 가져오기
    final currentTextTheme = Theme.of(context).textTheme;
    final Color transparentColor = Colors.transparent;

    // ticker 설정 정보 가져오기
    final tickerSetting = ref.watch(tickerSettingProvider);
    final bool? isBorderEnabled = tickerSetting.isBorderEnabled;
    final Color? upColor = tickerSetting.upColor;
    final Color? downColor = tickerSetting.downColor;

    // ticker 데이터 가져오기
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
                final TickerEntity ticker = filteredTickers[index];
                double currentPrice =
                    double.tryParse(ticker.recentData.price) ?? 0.0;
                double previousPrice =
                    double.tryParse(ticker.beforeData.price) ?? 0.0;

                bool isUpdatedRecently = ticker.recentData.isUpdatedRecently;
// 테두리 색상 결정
                late Color borderColor;
                if (isBorderEnabled != null) {
                  // isBorderEnabled 설정값 가져온 경우
                  if (isBorderEnabled) {
                    // 설정에서 테두리 깜빡임 활성화된 경우
                    if (isUpdatedRecently && currentPrice > previousPrice) {
                      borderColor = upColor ?? transparentColor; // 가격 상승
                    } else if (isUpdatedRecently &&
                        currentPrice < previousPrice) {
                      borderColor = downColor ?? transparentColor; // 가격 하락
                    } else {
                      borderColor = transparentColor; // 가격 동일하거나 깜빡임 종료
                    }
                  } else {
                    // 설정에서 테두리 깜빡임 비활성화된 경우
                    borderColor = transparentColor;
                  }
                } else {
                  // isBorderEnabled 설정값 가져오지 않은 경우
                  borderColor = transparentColor;
                }

// changePercent 결정 및 글자 색상 설정
                String changePercent =
                    ticker.recentData.changePercent24h.isNotEmpty
                        ? ticker.recentData.changePercent24h
                        : ticker.recentData.changePercentUtc9;
                Color? textColor;

                if (ticker.recentData.priceStatusEnum == PriceStatusEnum.up) {
                  textColor = upColor;
                } else if (ticker.recentData.priceStatusEnum ==
                    PriceStatusEnum.down) {
                  textColor = downColor;
                } else {
                  textColor = Colors.grey;
                }
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: FittedBox(
                          fit: BoxFit.scaleDown, // 텍스트가 길어질 경우 크기 조정
                          alignment: Alignment.centerLeft, // 왼쪽 정렬
                          child: Text(ticker.info.symbol),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          fit: BoxFit.scaleDown, // 텍스트가 길어질 경우 크기 조정
                          alignment: Alignment.centerRight, // 오른쪽 정렬
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: borderColor,
                                  width: 1), // 테두리 색상과 두께 설정
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    (currentTextTheme.bodyMedium?.fontSize ??
                                            18) /
                                        3,
                              ),
                              child: Text(
                                ticker.recentData.price,
                                style: TextStyle(color: textColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: FittedBox(
                          fit: BoxFit.scaleDown, // 텍스트가 길어질 경우 크기 조정
                          alignment: Alignment.centerRight, // 오른쪽 정렬
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: transparentColor, width: 1),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    (currentTextTheme.bodyMedium?.fontSize ??
                                            18) /
                                        3,
                              ),
                              child: Text(
                                changePercent,
                                style: TextStyle(color: textColor),
                              ),
                            ),
                          ),
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
