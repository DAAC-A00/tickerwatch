// ticker_info_service.dart

import 'package:tickerwatch/external/default/exchange_raw_category_enum.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_info_entity.dart';

// 만기 있는 상품 고유값 : BTC/USDT=0/0-2024y12m20d13h30m
// 무기한 상품 고유값 : BTC/USDT=0/0

class TickerInfoService {
  final List<ExchangeRawCategoryEnum> bitgetRawCategoryList = [
    ExchangeRawCategoryEnum.bitgetUmcbl,
    ExchangeRawCategoryEnum.bitgetDmcbl,
    ExchangeRawCategoryEnum.bitgetCmcbl
  ];
  late List<String> splitRawSymbol;
  late String tmpSymbol;

  // rawSymbol 예시
  //    bybit spot : BTCBRL, PEPEUSDC, DOGEEUR, 1SOLUSDT, 1INCHUSDT
  //    bybit linear : 10000000AIDOGEUSDT, 1000000PEIPEIUSDT, 10000COQUSDT, SHIB1000PERP, BTCPERP, BTC-06SEP24, BTC-25OCT24, BTC-27DEC24, BTC-27JUN25, BTC-27SEP24, BTC-28MAR25, BTC-30AUG24
  //    bybit inverse : BTCUSDZ24, BTCUSDU24, DOTUSD
  //    bitget umcbl : BTCUSDT_UMCBL
  //    bitget dmcbl : BTCUSD_DMCBL, ETHUSD_DMCBL_240927
  //    bitget cmcbl : ETHPERP_CMCBL
  //    okx SPOT : BTC-USDT
  //    okx SWAP : BTC-USD-SWAP, ETH-USDC-SWAP
  //    okx FUTURES : XRP-USDT-241227
  //    okx OPTION : BTC-USD-240906-62000-P, BTC-USD-241108-50000-C

  TickerInfoEntity? rawToTickerInfo(
      ExchangeRawCategoryEnum exchangeRawCategoryEnum, String rawSymbol,
      {String? subData, bool isPreferToFiat = false}) {
    // 불필요한 rawSymbol의 데이터 삭제해서 tmpSymbol 만들기
    // bitget의 _$rawCategory 문구 제거
    switch (exchangeRawCategoryEnum) {
      case ExchangeRawCategoryEnum.bitgetUmcbl:
        tmpSymbol = rawSymbol.replaceFirst('_UMCBL', '');
        break;
      case ExchangeRawCategoryEnum.bitgetDmcbl:
        tmpSymbol = rawSymbol.replaceFirst('_DMCBL', '');
        break;
      case ExchangeRawCategoryEnum.bitgetCmcbl:
        tmpSymbol = rawSymbol.replaceFirst('_CMCBL', '');
        break;
      case ExchangeRawCategoryEnum.okxSwap:
        tmpSymbol = rawSymbol.replaceFirst('_SWAP', '');
        break;
      default:
        tmpSymbol = rawSymbol; // 나머지는 rawSymbol 그대로 tmpSymbol로 가져오기
    }

    // tmpSymbol 예시
    //    bybit spot : BTCBRL, PEPEUSDC, DOGEEUR, 1SOLUSDT, 1INCHUSDT
    //    bybit linear : 10000000AIDOGEUSDT, 1000000PEIPEIUSDT, 10000COQUSDT, SHIB1000PERP, BTCPERP, BTC-06SEP24, BTC-25OCT24, BTC-27DEC24, BTC-27JUN25, BTC-27SEP24, BTC-28MAR25, BTC-30AUG24
    //    bybit inverse : BTCUSDZ24, BTCUSDU24, DOTUSD
    //    bitget umcbl : BTCUSDT
    //    bitget dmcbl : BTCUSD, ETHUSD_240927
    //    bitget cmcbl : ETHPERP
    //    okx SPOT : BTC-USDT
    //    okx SWAP : BTC-USD, ETH-USDC
    //    okx FUTURES : XRP-USDT-241227
    //    okx OPTION : BTC-USD-240906-62000-P, BTC-USD-241108-50000-C
    splitRawSymbol =
        tmpSymbol.contains('_') ? tmpSymbol.split('_') : tmpSymbol.split('-');
    return null;

    // TODO 이어서 데이터 가공 로직 구현 필요

    // tickerid 예시 : // BTC_0/USDT_0 OR BTC_0/USDT_0-2024y12m20d13h30m
  }
}
