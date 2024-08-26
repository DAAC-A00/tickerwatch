// exchange_raw_category_enum.dart

enum ExchangeRawCategoryEnum {
  bybitSpot,
  bybitLinear,
  bybitInverse,
  bitgetUmcbl,
  bitgetDmcbl,
  bitgetCmcbl,
  okxSpot,
  okxSwap,
  okxFutures,
  okxOption
}

extension ExchangeRawCategoryEnumExtension on ExchangeRawCategoryEnum {
  String get name {
    switch (this) {
      case ExchangeRawCategoryEnum.bybitSpot:
        return 'bybitSpot';
      case ExchangeRawCategoryEnum.bybitLinear:
        return 'bybitLinear';
      case ExchangeRawCategoryEnum.bybitInverse:
        return 'bybitInverse';
      case ExchangeRawCategoryEnum.bitgetUmcbl:
        return 'bitgetUmcbl';
      case ExchangeRawCategoryEnum.bitgetDmcbl:
        return 'bitgetDmcbl';
      case ExchangeRawCategoryEnum.bitgetCmcbl:
        return 'bitgetCmcbl';
      case ExchangeRawCategoryEnum.okxSpot:
        return 'okxSpot';
      case ExchangeRawCategoryEnum.okxSwap:
        return 'okxSwap';
      case ExchangeRawCategoryEnum.okxFutures:
        return 'okxFutures';
      case ExchangeRawCategoryEnum.okxOption:
        return 'okxOption';
      default:
        return '';
    }
  }

  String get allTickerListApiEndPoint {
    switch (this) {
      case ExchangeRawCategoryEnum.bybitSpot:
        return 'https://api.bybit.com/v5/market/tickers?category=spot';
      case ExchangeRawCategoryEnum.bybitLinear:
        return 'https://api.bybit.com/v5/market/tickers?category=linear';
      case ExchangeRawCategoryEnum.bybitInverse:
        return 'https://api.bybit.com/v5/market/tickers?category=inverse';
      case ExchangeRawCategoryEnum.bitgetUmcbl:
        return 'https://api.bitget.com/api/mix/v1/market/tickers?productType=umcbl';
      case ExchangeRawCategoryEnum.bitgetDmcbl:
        return 'https://api.bitget.com/api/mix/v1/market/tickers?productType=dmcbl';
      case ExchangeRawCategoryEnum.bitgetCmcbl:
        return 'https://api.bitget.com/api/mix/v1/market/tickers?productType=cmcbl';
      case ExchangeRawCategoryEnum.okxSpot:
        return 'https://www.okx.com/api/v5/market/tickers?instType=SPOT';
      case ExchangeRawCategoryEnum.okxSwap:
        return 'https://www.okx.com/api/v5/market/tickers?instType=SWAP';
      case ExchangeRawCategoryEnum.okxFutures:
        return 'https://www.okx.com/api/v5/market/tickers?instType=FUTURES';
      case ExchangeRawCategoryEnum.okxOption:
        return 'https://www.okx.com/api/v5/market/tickers?instType=OPTION';
      default:
        return '';
    }
  }
}
