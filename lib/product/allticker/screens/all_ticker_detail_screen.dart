// all_ticker_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/external/default/exchange_raw_category_enum.dart';
import 'package:tickerwatch/product/default/widgets/custom_modal_bottom_sheet.dart';
import 'package:tickerwatch/product/tickers/enums/category_enum.dart';
import 'package:tickerwatch/product/tickers/enums/option_type_enum.dart';
import '../../tickers/entities/ticker_entity.dart';
import '../../tickers/states/ticker_provider.dart'; // tickerProvider import

class AllTickerDetailScreen extends ConsumerWidget {
  final TickerEntity ticker;

  const AllTickerDetailScreen({super.key, required this.ticker});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // tickerProvider에서 모든 ticker 값을 가져옵니다.
    final tickers = ref.watch(tickerProvider);

    // 현재 ticker 정보를 찾습니다.
    final currentTicker = tickers.firstWhere(
      (t) =>
          t.info.rawSymbol == ticker.info.rawSymbol &&
          t.info.exchangeRawCategoryEnum == ticker.info.exchangeRawCategoryEnum,
      orElse: () => ticker, // 기본값으로 전달된 ticker를 사용
    );

    // 조건에 맞지 않는 키와 변수명 정보를 위한 리스트
    final List<String> missingInfo = [];

    return Scaffold(
      appBar: AppBar(
        title: Text(currentTicker.info.symbol),
        actions: [
          IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                String content = '';
                missingInfo.add('기본 Ticker 정보');
                content = currentTicker.info.symbol.isEmpty
                    ? '$content코드    ticker.info.rawSymbol\n'
                    : content;
                content = currentTicker.info.rawSymbol.isEmpty
                    ? '$content원본 코드    ticker.info.rawSymbol\n'
                    : content;
                content = currentTicker.info.symbolSub.isEmpty
                    ? '$content부제    ticker.info.symbolSub\n'
                    : content;
                content = currentTicker.info.unit.toString().isEmpty
                    ? '$content단위    ticker.info.unit.toString()\n'
                    : content;
                content = currentTicker.info.optionTypeEnum.name.isEmpty
                    ? '$content옵션 종류    ticker.info.optionTypeEnum.name\n'
                    : content;
                content = currentTicker.info.strikePrice.isEmpty
                    ? '$content행사 가격    ticker.info.strikePrice\n'
                    : content;
                content = currentTicker.info.expirationDate.isEmpty
                    ? '$content행사일    ticker.info.expirationDate\n'
                    : content;
                content = currentTicker.info.baseCode.isEmpty
                    ? '$content기초 코드    ticker.info.baseCode\n'
                    : content;
                content = currentTicker.info.quoteCode.isEmpty
                    ? '$content인용 코드    ticker.info.quoteCode\n'
                    : content;
                content = currentTicker.info.paymentCode.isEmpty
                    ? '$content결제 코드    ticker.info.paymentCode\n'
                    : content;
                content = currentTicker.info.baseCountry.isEmpty
                    ? '$content기초 국가    ticker.info.baseCountry\n'
                    : content;
                content = currentTicker.info.quoteCountry.isEmpty
                    ? '$content인용 국가    ticker.info.quoteCountry\n'
                    : content;
                content = currentTicker.info.paymentCountry.isEmpty
                    ? '$content결제 국가    ticker.info.paymentCountry\n'
                    : content;
                content = currentTicker.info.categoryEnum.name.isEmpty
                    ? '$content카테고리    ticker.info.categoryEnum.name\n'
                    : content;
                content = currentTicker.info.source.isEmpty
                    ? '$content정보 출처    ticker.info.source\n'
                    : content;
                content = currentTicker.info.remark.isEmpty
                    ? '$content비고    ticker.info.remark\n'
                    : content;
                content = currentTicker.info.searchKeywords.isEmpty
                    ? '$content검색 키워드    ticker.info.searchKeywords\n'
                    : content;
                content = currentTicker.recentData.price.isEmpty
                    ? '$content현재가    ticker.recentData.price\n'
                    : content;
                content = currentTicker.recentData.lastPrice.isEmpty
                    ? '$content최근 체결가    ticker.recentData.lastPrice\n'
                    : content;
                content = currentTicker.recentData.highPrice24h.isEmpty
                    ? '$content최고가(24h)    ticker.recentData.highPrice24h\n'
                    : content;
                content = currentTicker.recentData.lowPrice24h.isEmpty
                    ? '$content최저가(24h)    ticker.recentData.lowPrice24h\n'
                    : content;
                content = currentTicker.recentData.changePercent24h.isEmpty
                    ? '$content변동률(24h)    ticker.recentData.changePercent24h\n'
                    : content;
                content = currentTicker.recentData.volume24h.isEmpty
                    ? '$content거래량(24h)    ticker.recentData.volume24h\n'
                    : content;
                content = currentTicker.recentData.turnOver24h.isEmpty
                    ? '$content거래대금(24h)    ticker.recentData.turnOver24h\n'
                    : content;
                content = currentTicker.recentData.prevPrice24h.isEmpty
                    ? '$content이전 가격(24h)    ticker.recentData.prevPrice24h\n'
                    : content;
                content = currentTicker.recentData.changePercentUtc0.isEmpty
                    ? '$content변동률(UTC0)    ticker.recentData.changePercentUtc0\n'
                    : content;
                content = currentTicker.recentData.prevPriceUtc0.isEmpty
                    ? '$content이전 가격(UTC0)    ticker.recentData.prevPriceUtc0\n'
                    : content;
                content = currentTicker.recentData.highPriceUtc0.isEmpty
                    ? '$content최고가(UTC0)    ticker.recentData.highPriceUtc0\n'
                    : content;
                content = currentTicker.recentData.lowPriceUtc0.isEmpty
                    ? '$content최저가(UTC0)    ticker.recentData.lowPriceUtc0\n'
                    : content;
                content = currentTicker.recentData.turnOverUtc0.isEmpty
                    ? '$content거래대금(UTC0)    ticker.recentData.turnOverUtc0\n'
                    : content;
                content = currentTicker.recentData.volumeUtc0.isEmpty
                    ? '$content거래량(UTC0)    ticker.recentData.volumeUtc0\n'
                    : content;
                content = currentTicker.recentData.changePercentUtc9.isEmpty
                    ? '$content변동률(UTC9)    ticker.recentData.changePercentUtc9\n'
                    : content;
                content = currentTicker.recentData.ask1Price.isEmpty
                    ? '$content매도 1호가    ticker.recentData.ask1Price\n'
                    : content;
                content = currentTicker.recentData.ask1Size.isEmpty
                    ? '$content매도 1호가 수량    ticker.recentData.ask1Size\n'
                    : content;
                content = currentTicker.recentData.bid1Price.isEmpty
                    ? '$content매수 1호가    ticker.recentData.bid1Price\n'
                    : content;
                content = currentTicker.recentData.bid1Size.isEmpty
                    ? '$content매수 1호가 수량    ticker.recentData.bid1Size\n'
                    : content;
                content = currentTicker.recentData.dataAt.isEmpty
                    ? '$content데이터 기록 시점    ticker.recentData.dataAt\n'
                    : content;
                content = currentTicker.recentData.updatedAt.isEmpty
                    ? '$content업데이트 시점    ticker.recentData.updatedAt\n'
                    : content;
                content = currentTicker.recentData.priceStatusEnum.name.isEmpty
                    ? '$content가격 상태    ticker.recentData.priceStatusEnum.name\n'
                    : content;
                // 무조건 값을 가지는 currentTicker.recentData.isUpdatedRecently 정보는 여기에서 노출하지 않음
                content.length <= 2
                    ? missingInfo.add(content)
                    : missingInfo.add(content.substring(
                        0, content.length - 2)); // 마지막 "\n"은 삭제해주기
                // beforeData
                missingInfo.add('beforeData 정보');
                String contentBeforeData = '';
                contentBeforeData = currentTicker.beforeData.price.isEmpty
                    ? '$contentBeforeData현재가    ticker.beforeData.price\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker.beforeData.lastPrice.isEmpty
                    ? '$contentBeforeData최근 체결가    ticker.beforeData.lastPrice\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker
                        .beforeData.highPrice24h.isEmpty
                    ? '$contentBeforeData최고가(24h)    ticker.beforeData.highPrice24h\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker.beforeData.lowPrice24h.isEmpty
                    ? '$contentBeforeData최저가(24h)    ticker.beforeData.lowPrice24h\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker
                        .beforeData.changePercent24h.isEmpty
                    ? '$contentBeforeData변동률(24h)    ticker.beforeData.changePercent24h\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker.beforeData.volume24h.isEmpty
                    ? '$contentBeforeData거래량(24h)    ticker.beforeData.volume24h\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker.beforeData.turnOver24h.isEmpty
                    ? '$contentBeforeData거래대금(24h)    ticker.beforeData.turnOver24h\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker
                        .beforeData.prevPrice24h.isEmpty
                    ? '$contentBeforeData이전 가격(24h)    ticker.beforeData.prevPrice24h\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker
                        .beforeData.changePercentUtc0.isEmpty
                    ? '$contentBeforeData변동률(UTC0)    ticker.beforeData.changePercentUtc0\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker
                        .beforeData.prevPriceUtc0.isEmpty
                    ? '$contentBeforeData이전 가격(UTC0)    ticker.beforeData.prevPriceUtc0\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker
                        .beforeData.highPriceUtc0.isEmpty
                    ? '$contentBeforeData최고가(UTC0)    ticker.beforeData.highPriceUtc0\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker
                        .beforeData.lowPriceUtc0.isEmpty
                    ? '$contentBeforeData최저가(UTC0)    ticker.beforeData.lowPriceUtc0\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker
                        .beforeData.turnOverUtc0.isEmpty
                    ? '$contentBeforeData거래대금(UTC0)    ticker.beforeData.turnOverUtc0\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker.beforeData.volumeUtc0.isEmpty
                    ? '$contentBeforeData거래량(UTC0)    ticker.beforeData.volumeUtc0\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker
                        .beforeData.changePercentUtc9.isEmpty
                    ? '$contentBeforeData변동률(UTC9)    ticker.beforeData.changePercentUtc9\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker.beforeData.ask1Price.isEmpty
                    ? '$contentBeforeData매도 1호가    ticker.beforeData.ask1Price\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker.beforeData.ask1Size.isEmpty
                    ? '$contentBeforeData매도 1호가 수량    ticker.beforeData.ask1Size\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker.beforeData.bid1Price.isEmpty
                    ? '$contentBeforeData매수 1호가    ticker.beforeData.bid1Price\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker.beforeData.bid1Size.isEmpty
                    ? '$contentBeforeData매수 1호가 수량    ticker.beforeData.bid1Size\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker.beforeData.dataAt.isEmpty
                    ? '$contentBeforeData데이터 기록 시점    ticker.beforeData.dataAt\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker.beforeData.updatedAt.isEmpty
                    ? '$contentBeforeData업데이트 시점    ticker.beforeData.updatedAt\n'
                    : contentBeforeData;
                contentBeforeData = currentTicker
                        .beforeData.priceStatusEnum.name.isEmpty
                    ? '$contentBeforeData가격 상태    ticker.beforeData.priceStatusEnum.name\n'
                    : contentBeforeData;
                // 무조건 값을 가지는 currentTicker.recentData.isUpdatedRecently 정보는 여기에서 노출하지 않음
                missingInfo.add(contentBeforeData);
                // BottomSheet 호출
                showCustomModalBottomSheet(
                    context, 'ℹ️ 제공되지 않는 정보', missingInfo);
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // TickerInfoModel의 데이터 출력
            const ListTile(
              leading: Icon(Icons.info),
              title: Text('info'),
            ),
            if (currentTicker.info.symbol.isNotEmpty)
              _buildRow('코드', currentTicker.info.symbol),
            if (currentTicker.info.rawSymbol.isNotEmpty)
              _buildRow('원본 코드', currentTicker.info.rawSymbol),
            if (currentTicker.info.symbolSub.isNotEmpty)
              _buildRow('부제', currentTicker.info.symbolSub),
            if (currentTicker.info.unit > 0)
              _buildRow('단위', currentTicker.info.unit.toString()),
            if (currentTicker.info.optionTypeEnum != OptionTypeEnum.none)
              _buildRow('옵션 종류', currentTicker.info.optionTypeEnum.name),
            if (currentTicker.info.strikePrice.isNotEmpty)
              _buildRow('행사 가격', currentTicker.info.strikePrice),
            if (currentTicker.info.expirationDate.isNotEmpty)
              _buildRow('행사일', currentTicker.info.expirationDate),
            if (currentTicker.info.baseCode.isNotEmpty)
              _buildRow('기초 코드', currentTicker.info.baseCode),
            if (currentTicker.info.quoteCode.isNotEmpty)
              _buildRow('인용 코드', currentTicker.info.quoteCode),
            if (currentTicker.info.paymentCode.isNotEmpty)
              _buildRow('결제 코드', currentTicker.info.paymentCode),
            if (currentTicker.info.baseCountry.isNotEmpty)
              _buildRow('기초 국가', currentTicker.info.baseCountry),
            if (currentTicker.info.quoteCountry.isNotEmpty)
              _buildRow('인용 국가', currentTicker.info.quoteCountry),
            if (currentTicker.info.paymentCountry.isNotEmpty)
              _buildRow('결제 국가', currentTicker.info.paymentCountry),
            if (currentTicker.info.categoryEnum != CategoryEnum.none)
              _buildRow('카테고리', currentTicker.info.categoryEnum.name),
            if (currentTicker.info.exchangeRawCategoryEnum !=
                ExchangeRawCategoryEnum.none)
              _buildRow(
                  '원본 카테고리', currentTicker.info.exchangeRawCategoryEnum.name),
            if (currentTicker.info.source.isNotEmpty)
              _buildRow('정보 출처', currentTicker.info.source),
            if (currentTicker.info.remark.isNotEmpty)
              _buildRow('비고', currentTicker.info.remark),
            if (currentTicker.info.searchKeywords.isNotEmpty)
              _buildRow('검색 키워드', currentTicker.info.searchKeywords),

            // recentData인 TickerModel의 데이터 출력
            const ListTile(
              leading: Icon(Icons.looks_one_outlined),
              title: Text('recentData'),
            ),
            if (currentTicker.recentData.price.isNotEmpty)
              _buildRow('현재가', currentTicker.recentData.price),
            if (currentTicker.recentData.lastPrice.isNotEmpty)
              _buildRow('최근 체결가', currentTicker.recentData.lastPrice),
            if (currentTicker.recentData.highPrice24h.isNotEmpty)
              _buildRow('최고가(24h)', currentTicker.recentData.highPrice24h),
            if (currentTicker.recentData.lowPrice24h.isNotEmpty)
              _buildRow('최저가(24h)', currentTicker.recentData.lowPrice24h),
            if (currentTicker.recentData.changePercent24h.isNotEmpty)
              _buildRow('변동률(24h)', currentTicker.recentData.changePercent24h),
            if (currentTicker.recentData.volume24h.isNotEmpty)
              _buildRow('거래량(24h)', currentTicker.recentData.volume24h),
            if (currentTicker.recentData.turnOver24h.isNotEmpty)
              _buildRow('거래대금(24h)', currentTicker.recentData.turnOver24h),
            if (currentTicker.recentData.prevPrice24h.isNotEmpty)
              _buildRow('이전 가격(24h)', currentTicker.recentData.prevPrice24h),
            if (currentTicker.recentData.changePercentUtc0.isNotEmpty)
              _buildRow(
                  '변동률(UTC0)', currentTicker.recentData.changePercentUtc0),
            if (currentTicker.recentData.prevPriceUtc0.isNotEmpty)
              _buildRow('이전 가격(UTC0)', currentTicker.recentData.prevPriceUtc0),
            if (currentTicker.recentData.highPriceUtc0.isNotEmpty)
              _buildRow('최고가(UTC0)', currentTicker.recentData.highPriceUtc0),
            if (currentTicker.recentData.lowPriceUtc0.isNotEmpty)
              _buildRow('최저가(UTC0)', currentTicker.recentData.lowPriceUtc0),
            if (currentTicker.recentData.turnOverUtc0.isNotEmpty)
              _buildRow('거래대금(UTC0)', currentTicker.recentData.turnOverUtc0),
            if (currentTicker.recentData.volumeUtc0.isNotEmpty)
              _buildRow('거래량(UTC0)', currentTicker.recentData.volumeUtc0),
            if (currentTicker.recentData.changePercentUtc9.isNotEmpty)
              _buildRow(
                  '변동률(UTC9)', currentTicker.recentData.changePercentUtc9),

            // recentData인 TickerModel 추가 데이터 출력
            if (currentTicker.recentData.ask1Price.isNotEmpty)
              _buildRow('매도 1호가', currentTicker.recentData.ask1Price),
            if (currentTicker.recentData.ask1Size.isNotEmpty)
              _buildRow('매도 1호가 수량', currentTicker.recentData.ask1Size),
            if (currentTicker.recentData.bid1Price.isNotEmpty)
              _buildRow('매수 1호가', currentTicker.recentData.bid1Price),
            if (currentTicker.recentData.bid1Size.isNotEmpty)
              _buildRow('매수 1호가 수량', currentTicker.recentData.bid1Size),
            if (currentTicker.recentData.dataAt.isNotEmpty)
              _buildRow('데이터 기록 시점', currentTicker.recentData.dataAt),
            if (currentTicker.recentData.updatedAt.isNotEmpty)
              _buildRow('업데이트 시점', currentTicker.recentData.updatedAt),
            _buildRow('가격 상태', currentTicker.recentData.priceStatusEnum.name),
            _buildRow('근 0.x초 이내 변경 여부',
                currentTicker.recentData.isUpdatedRecently.toString()),

            // beforeData인 TickerModel의 데이터 출력
            const ListTile(
              leading: Icon(Icons.looks_two_outlined),
              title: Text('beforeData'),
            ),
            if (currentTicker.beforeData.price.isNotEmpty)
              _buildRow('현재가', currentTicker.beforeData.price),
            if (currentTicker.beforeData.lastPrice.isNotEmpty)
              _buildRow('최근 체결가', currentTicker.beforeData.lastPrice),
            if (currentTicker.beforeData.highPrice24h.isNotEmpty)
              _buildRow('최고가(24h)', currentTicker.beforeData.highPrice24h),
            if (currentTicker.beforeData.lowPrice24h.isNotEmpty)
              _buildRow('최저가(24h)', currentTicker.beforeData.lowPrice24h),
            if (currentTicker.beforeData.changePercent24h.isNotEmpty)
              _buildRow('변동률(24h)', currentTicker.beforeData.changePercent24h),
            if (currentTicker.beforeData.volume24h.isNotEmpty)
              _buildRow('거래량(24h)', currentTicker.beforeData.volume24h),
            if (currentTicker.beforeData.turnOver24h.isNotEmpty)
              _buildRow('거래대금(24h)', currentTicker.beforeData.turnOver24h),
            if (currentTicker.beforeData.prevPrice24h.isNotEmpty)
              _buildRow('이전 가격(24h)', currentTicker.beforeData.prevPrice24h),
            if (currentTicker.beforeData.changePercentUtc0.isNotEmpty)
              _buildRow(
                  '변동률(UTC0)', currentTicker.beforeData.changePercentUtc0),
            if (currentTicker.beforeData.prevPriceUtc0.isNotEmpty)
              _buildRow('이전 가격(UTC0)', currentTicker.beforeData.prevPriceUtc0),
            if (currentTicker.beforeData.highPriceUtc0.isNotEmpty)
              _buildRow('최고가(UTC0)', currentTicker.beforeData.highPriceUtc0),
            if (currentTicker.beforeData.lowPriceUtc0.isNotEmpty)
              _buildRow('최저가(UTC0)', currentTicker.beforeData.lowPriceUtc0),
            if (currentTicker.beforeData.turnOverUtc0.isNotEmpty)
              _buildRow('거래대금(UTC0)', currentTicker.beforeData.turnOverUtc0),
            if (currentTicker.beforeData.volumeUtc0.isNotEmpty)
              _buildRow('거래량(UTC0)', currentTicker.beforeData.volumeUtc0),
            if (currentTicker.beforeData.changePercentUtc9.isNotEmpty)
              _buildRow(
                  '변동률(UTC9)', currentTicker.beforeData.changePercentUtc9),

            // beforeData인 TickerModel 추가 데이터 출력
            if (currentTicker.beforeData.ask1Price.isNotEmpty)
              _buildRow('매도 1호가', currentTicker.beforeData.ask1Price),
            if (currentTicker.beforeData.ask1Size.isNotEmpty)
              _buildRow('매도 1호가 수량', currentTicker.beforeData.ask1Size),
            if (currentTicker.beforeData.bid1Price.isNotEmpty)
              _buildRow('매수 1호가', currentTicker.beforeData.bid1Price),
            if (currentTicker.beforeData.bid1Size.isNotEmpty)
              _buildRow('매수 1호가 수량', currentTicker.beforeData.bid1Size),
            if (currentTicker.beforeData.dataAt.isNotEmpty)
              _buildRow('데이터 기록 시점', currentTicker.beforeData.dataAt),
            if (currentTicker.beforeData.updatedAt.isNotEmpty)
              _buildRow('업데이트 시점', currentTicker.beforeData.updatedAt),
            _buildRow('근 0.x초 이내 변경 여부',
                currentTicker.beforeData.isUpdatedRecently.toString()),
            _buildRow('가격 상태', currentTicker.beforeData.priceStatusEnum.name),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 1, child: Text(key)),
          Expanded(flex: 2, child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
