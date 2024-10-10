// exchange_raw_category_enum.dart

enum ExchangeRawCategoryEnum {
  none,
  bybitSpot,
  bybitLinear,
  bybitInverse,
  bitgetSpot,
  bitgetUmcbl,
  bitgetDmcbl,
  bitgetCmcbl,
  okxSpot,
  okxSwap,
  okxFutures,
  okxOption,
  binanceSpot,
  binanceCm,
  binanceUm,
  upbitSpot,
  bithumbSpot,
  naverMarketIndexWeb,
}

extension ExchangeRawCategoryEnumExtension on ExchangeRawCategoryEnum {
  String get name {
    switch (this) {
      case ExchangeRawCategoryEnum.none:
        return '';
      case ExchangeRawCategoryEnum.bybitSpot:
        return 'bybitSpot';
      case ExchangeRawCategoryEnum.bybitLinear:
        return 'bybitLinear';
      case ExchangeRawCategoryEnum.bybitInverse:
        return 'bybitInverse';
      case ExchangeRawCategoryEnum.bitgetSpot:
        return 'bitgetSpot';
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
      case ExchangeRawCategoryEnum.binanceSpot:
        return 'binanceSpot';
      case ExchangeRawCategoryEnum.binanceCm:
        return 'binanceCm';
      case ExchangeRawCategoryEnum.binanceUm:
        return 'binanceUm';
      case ExchangeRawCategoryEnum.upbitSpot:
        return 'upbitSpot';
      case ExchangeRawCategoryEnum.bithumbSpot:
        return 'bithumbSpot';
      case ExchangeRawCategoryEnum.naverMarketIndexWeb:
        return 'naverMarketIndexWeb';
    }
  }

  String get allTickerListApiEndPoint {
    switch (this) {
      case ExchangeRawCategoryEnum.none:
        return '';
      case ExchangeRawCategoryEnum.bybitSpot:
        return 'https://api.bybit.com/v5/market/tickers?category=spot';
      case ExchangeRawCategoryEnum.bybitLinear:
        return 'https://api.bybit.com/v5/market/tickers?category=linear';
      case ExchangeRawCategoryEnum.bybitInverse:
        return 'https://api.bybit.com/v5/market/tickers?category=inverse';
      case ExchangeRawCategoryEnum.bitgetSpot:
        return 'https://api.bitget.com/api/spot/v1/market/tickers';
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
      case ExchangeRawCategoryEnum.binanceSpot:
        return 'https://api.binance.com/api/v3/ticker/24hr';
      case ExchangeRawCategoryEnum.binanceCm:
        return 'https://dapi.binance.com/dapi/v1/ticker/24hr';
      case ExchangeRawCategoryEnum.binanceUm:
        return 'https://fapi.binance.com/fapi/v1/ticker/24hr';
      case ExchangeRawCategoryEnum.upbitSpot:
        return '';
      // https://api.upbit.com/v1/ticker?markets=KRW-BTC
      // https://api.upbit.com/v1/market/all?isDetails=true
      case ExchangeRawCategoryEnum.bithumbSpot:
        return 'https://api.bithumb.com/public/ticker';
      case ExchangeRawCategoryEnum.naverMarketIndexWeb:
        return 'https://finance.naver.com/marketindex/?tabSel=exchange';
    }
  }
}
