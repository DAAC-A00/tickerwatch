// exchange_raw_category_enum.dart

enum ExchangeRawCategoryEnum {
  bybitSpot,
}

extension ExchangeRawCategoryEnumExtension on ExchangeRawCategoryEnum {
  String get name {
    switch (this) {
      case ExchangeRawCategoryEnum.bybitSpot:
        return 'bybitSpot';
      default:
        return '';
    }
  }

  String get allTickerListApiEndPoint {
    switch (this) {
      case ExchangeRawCategoryEnum.bybitSpot:
        return "https://api.bybit.com/v5/market/tickers?category=spot";
      default:
        return '';
    }
  }
}
