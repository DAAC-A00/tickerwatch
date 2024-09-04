// ticker_display_entity.dart

import 'package:tickerwatch/external/default/exchange_raw_category_enum.dart';
import 'package:tickerwatch/product/tickers/enums/category_exchange_enum.dart';

class TickerDisplayEntity {
  // 이용자 선택 또는 입력
  CategoryExchangeEnum categoryExchangeEnum;
  String symbol;
  String price;
  // 자동 세팅
  bool isUp;
  ExchangeRawCategoryEnum exchangeRawCategoryEnum;

  TickerDisplayEntity({
    required this.categoryExchangeEnum,
    required this.symbol,
    required this.price,
    required this.isUp,
    required this.exchangeRawCategoryEnum,
  });
}
