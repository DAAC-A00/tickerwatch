// all_ticker_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/external/default/exchange_raw_category_enum.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(currentTicker.info.rawSymbol),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // TickerInfoModel의 데이터 출력
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

            // TickerEntity의 데이터 출력
            if (currentTicker.price.isNotEmpty)
              _buildRow('현재가', currentTicker.price),
            if (currentTicker.lastPrice.isNotEmpty)
              _buildRow('최근 체결가', currentTicker.lastPrice),
            if (currentTicker.highPrice24h.isNotEmpty)
              _buildRow('최고가(24h)', currentTicker.highPrice24h),
            if (currentTicker.lowPrice24h.isNotEmpty)
              _buildRow('최저가(24h)', currentTicker.lowPrice24h),
            if (currentTicker.changePercent24h.isNotEmpty)
              _buildRow('변동률', currentTicker.changePercent24h),
            if (currentTicker.volume24h.isNotEmpty)
              _buildRow('거래량', currentTicker.volume24h),
            if (currentTicker.turnOver24h.isNotEmpty)
              _buildRow('거래대금', currentTicker.turnOver24h),
            if (currentTicker.prevPrice24h.isNotEmpty)
              _buildRow('이전 가격(24h)', currentTicker.prevPrice24h),
            if (currentTicker.changePercentUtc0.isNotEmpty)
              _buildRow('변동률(UTC0)', currentTicker.changePercentUtc0),
            if (currentTicker.prevPriceUtc0.isNotEmpty)
              _buildRow('이전 가격(UTC0)', currentTicker.prevPriceUtc0),
            if (currentTicker.highPriceUtc0.isNotEmpty)
              _buildRow('최고가(UTC0)', currentTicker.highPriceUtc0),
            if (currentTicker.lowPriceUtc0.isNotEmpty)
              _buildRow('최저가(UTC0)', currentTicker.lowPriceUtc0),
            if (currentTicker.turnOverUtc0.isNotEmpty)
              _buildRow('거래대금(UTC0)', currentTicker.turnOverUtc0),
            if (currentTicker.volumeUtc0.isNotEmpty)
              _buildRow('거래량(UTC0)', currentTicker.volumeUtc0),

            // TickerEntity 추가 데이터 출력
            if (currentTicker.ask1Price.isNotEmpty)
              _buildRow('매도 1호가', currentTicker.ask1Price),
            if (currentTicker.ask1Size.isNotEmpty)
              _buildRow('매도 1호가 수량', currentTicker.ask1Size),
            if (currentTicker.bid1Price.isNotEmpty)
              _buildRow('매수 1호가', currentTicker.bid1Price),
            if (currentTicker.bid1Size.isNotEmpty)
              _buildRow('매수 1호가 수량', currentTicker.bid1Size),
            if (currentTicker.dataAt.isNotEmpty)
              _buildRow('데이터 기록 시점', currentTicker.dataAt),
            if (currentTicker.updatedAt.isNotEmpty)
              _buildRow('업데이트 시점', currentTicker.updatedAt),
            _buildRow('가격 상태', currentTicker.priceStatusEnum.name),
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
