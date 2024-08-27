// ticker_info_model.dart

import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:tickerwatch/external/default/exchange_raw_category_enum.dart';
import 'package:tickerwatch/product/tickers/enums/option_type_enum.dart';

import '../enums/category_exchange_enum.dart';

class TickerInfoModel {
  // tickerId
  //    무기한 상품 고유값 ex1 : BTC_0/USDT_0
  //    무기한 상품 고유값 ex2 : BTC_1/KRW_0
  //    만기 있는 상품 고유값 : BTC_0/USDT_0-2024y12m20d
  final String tickerId;
  // symbol
  final String rawSymbol; // 1000PEPEPERP
  final String symbolSub; // PERP
  final int unit; // 1000

  // option 관련
  OptionTypeEnum optionTypeEnum; // 옵션 종류
  String strikePrice; // 행사 가격
  String expirationDate; // 행사일

  // Codes
  final String baseCode; // PEPE_0
  final String quoteCode; // USDC_0
  final String paymentCode; // USDC_0
  final String baseCodeKorean;
  final String quoteCodeKorean;
  final String paymentCodeKorean;

  // Groups
  final String baseGroup;
  final String quoteGroup;
  final String paymentGroup;
  final String baseGroupKorean;
  final String quoteGroupKorean;
  final String paymentGroupKorean;

  // Countries
  final String baseCountry;
  final String quoteCountry;
  final String paymentCountry;
  final String baseCountryKorean;
  final String quoteCountryKorean;
  final String paymentCountryKorean;

  // category
  final String rawCategory;
  final String category;
  final ExchangeRawCategoryEnum exchangeRawCategoryEnum; // 정보 공유자
  final CategoryExchangeEnum categoryExchangeEnum;
  final String source; // 정보 출처

  // etc
  final String remark;
  final String searchKeywords;

  TickerInfoModel({
    required this.tickerId,
    // raw
    required this.rawSymbol,
    required this.symbolSub,
    required this.unit,
    // option 관련
    required this.optionTypeEnum,
    required this.strikePrice,
    required this.expirationDate,
    // Code
    required this.baseCode,
    required this.quoteCode,
    required this.paymentCode,
    required this.baseCodeKorean,
    required this.quoteCodeKorean,
    required this.paymentCodeKorean,
    // Group
    required this.baseGroup,
    required this.quoteGroup,
    required this.paymentGroup,
    required this.baseGroupKorean,
    required this.quoteGroupKorean,
    required this.paymentGroupKorean,
    // Country
    required this.baseCountry,
    required this.quoteCountry,
    required this.paymentCountry,
    required this.baseCountryKorean,
    required this.quoteCountryKorean,
    required this.paymentCountryKorean,
    // category
    required this.rawCategory,
    required this.category,
    required this.exchangeRawCategoryEnum,
    required this.categoryExchangeEnum,
    required this.source,
    required this.remark,
    required this.searchKeywords,
  });

  // rawSymbol 예시
  //    bybit spot : BTCBRL, PEPEUSDC, DOGEEUR, 1SOLUSDT, 1INCHUSDT
  //    bybit linear : 10000000AIDOGEUSDT, 1000000PEIPEIUSDT, 10000COQUSDT, SHIB1000PERP, BTCPERP, BTC-06SEP24, BTC-25OCT24, BTC-27DEC24, BTC-27JUN25, BTC-27SEP24, BTC-28MAR25, BTC-30AUG24
  //    bybit inverse : BTCUSDZ24, BTCUSDU24, DOTUSD
  //    bitget spot : BTCUSDT, ETHBTC, 3ULLUSDT, API3USDT, BTCBRL
  //    bitget umcbl : BTCUSDT_UMCBL
  //    bitget dmcbl : BTCUSD_DMCBL, ETHUSD_DMCBL_240927
  //    bitget cmcbl : ETHPERP_CMCBL
  //    okx SPOT : BTC-USDT
  //    okx SWAP : BTC-USD-SWAP, ETH-USDC-SWAP
  //    okx FUTURES : XRP-USDT-241227
  //    okx OPTION : BTC-USD-240906-62000-P, BTC-USD-241108-50000-C
  //    binance spot : BNBETH, ETHUSDT, 1000SATSTRY, 1000SATSFDUSD
  //    binance cm : ETHUSD_240927, ETHUSD_PERP, UNIUSD_PERP, LTCUSD_241227
  //    binance um : BTCUSDT_241227, BTCUSDC, 1000PEPEUSDT, 1000SHIBUSDC
  //    upbit spot : KRW-BTC, USDT-BTC, BTC-APE   (quoteCode-baseCode)
  //    bithumb spot : BTC, ETH

  TickerInfoModel? rawToTickerInfo(
      ExchangeRawCategoryEnum exchangeRawCategoryEnum, String rawSymbol,
      {String? subData, bool isPreferToFiat = false}) {
    late String tmpSymbol;
    late List<String> splitSymbol;

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
    //    binance spot : BNBETH, ETHUSDT, 1000SATSTRY, 1000SATSFDUSD
    //    binance cm : ETHUSD_240927, ETHUSD_PERP, UNIUSD_PERP, LTCUSD_241227
    //    binance um : BTCUSDT_241227, BTCUSDC, 1000PEPEUSDT, 1000SHIBUSDC
    //    upbit spot : KRW-BTC, USDT-BTC, BTC-APE   (quoteCode-baseCode)
    //    bithumb spot : BTC, ETH
    switch (exchangeRawCategoryEnum) {
      case ExchangeRawCategoryEnum.bitgetDmcbl:
      case ExchangeRawCategoryEnum.binanceCm:
      case ExchangeRawCategoryEnum.binanceUm:
        splitSymbol = tmpSymbol.split('_');
        break;
      default:
        splitSymbol = tmpSymbol.split('-');
    }

    // splitSymbol 예시
    //    bybit spot : length 1 -> BTCBRL, PEPEUSDC, DOGEEUR, 1SOLUSDT, 1INCHUSDT
    //    bybit linear : length 1, 2 유기한 -> 10000000AIDOGEUSDT, 1000000PEIPEIUSDT, 10000COQUSDT, SHIB1000PERP, BTCPERP, [BTC, 06SEP24], [BTC, 25OCT24], [BTC, 27DEC24], [BTC, 27JUN25], [BTC, 27SEP24], [BTC, 28MAR25], [BTC, 30AUG24]
    //    bybit inverse : length 1 -> BTCUSDZ24, BTCUSDU24, DOTUSD
    //    bitget umcbl : length 1 -> BTCUSDT
    //    bitget dmcbl : length 1, 2 유기한 -> BTCUSD, [ETHUSD, 240927]
    //    bitget cmcbl : length 1 -> ETHPERP
    //    okx SPOT : length 2 -> [BTC, USDT]
    //    okx SWAP : length 2 -> [BTC, USD], [ETH, USDC]
    //    okx FUTURES : length 3 유기한 -> [XRP, USDT, 241227]
    //    okx OPTION : length 5 유기한 -> [BTC, USD, 240906, 62000, P], [BTC, USD, 241108, 50000, C]
    //    binance spot : length 1 -> BNBETH, ETHUSDT, 1000SATSTRY, 1000SATSFDUSD
    //    binance cm : length 2 무/유기한 -> [ETHUSD, 240927], [ETHUSD, PERP], [UNIUSD, PERP], [LTCUSD, 241227]
    //    binance um : length 1, 2 유기한 -> [BTCUSDT, 241227], [BTCUSDC], [1000PEPEUSDT], [1000SHIBUSDC]
    //    upbit spot : length 2 -> [KRW, BTC], [USDT, BTC], [BTC, APE]       (quoteCode-baseCode)
    //    bithumb spot : length 1 -> [BTC], [ETH]

    expirationDate = _getExpirationDate(exchangeRawCategoryEnum, splitSymbol);

    // category 확보

    // TODO quoteCode 분리
    // TODO unit & baseCode 분리

    // TODO 이어서 데이터 가공 로직 구현 필요

    return null;

    // tickerid 예시 : // BTC_0/USDT_0 OR BTC_0/USDT_0-2024y12m20d13h30m
  }

  String _extractExpirationDate(String rawExpirationDate) {
    // 월 약어와 숫자 매핑
    final Map<String, String> monthMap = {
      'JAN': '01',
      'FEB': '02',
      'MAR': '03',
      'APR': '04',
      'MAY': '05',
      'JUN': '06',
      'JUL': '07',
      'AUG': '08',
      'SEP': '09',
      'OCT': '10',
      'NOV': '11',
      'DEC': '12',
    };

    // 정규 표현식을 사용하여 문자열을 분리
    RegExp regExp = RegExp(r'(\d{2})([A-Z]{3})(\d{2})');
    Match? match = regExp.firstMatch(rawExpirationDate);

    if (match != null) {
      String? day = match.group(1);
      String? month = monthMap[match.group(2)];
      String? year = match.group(3) != null ? '20${match.group(3)!}' : null;

      if (day != null && month != null && year != null) {
        return '$year$month$day'; // 유기한인 경우
      }
    }
    return ''; // PERP인 경우
  }

  String _getExpirationDate(ExchangeRawCategoryEnum exchangeRawCategoryEnum,
      List<String> splitSymbol) {
    switch (exchangeRawCategoryEnum) {
      case ExchangeRawCategoryEnum.bybitLinear:
        if (splitSymbol.length == 2) {
          return _extractExpirationDate(splitSymbol.last);
        }
        break;

      case ExchangeRawCategoryEnum.bitgetDmcbl:
      case ExchangeRawCategoryEnum.binanceUm:
        if (splitSymbol.length == 2) {
          return '20${splitSymbol.last}';
        }
        break;

      case ExchangeRawCategoryEnum.okxFutures:
        return '20${splitSymbol.last}';
      case ExchangeRawCategoryEnum.okxOption:
        if (splitSymbol.length == 5) {
          strikePrice = splitSymbol[3];
          if (splitSymbol.last == 'C') {
            optionTypeEnum = OptionTypeEnum.call;
          } else if (splitSymbol.last == 'P') {
            optionTypeEnum = OptionTypeEnum.put;
          } else {
            // OptionTypeEnum.none으로 설정되었을 때 로그 출력
            log('[WARN][TickerInfoModel._getExpirationDate] splitSymbol.last not in ["C", "P"]. But OPTION has only Call or Put.');
            optionTypeEnum = OptionTypeEnum.none;
          }
          return splitSymbol[2];
        } else {
          log('[WARN][TickerInfoModel._getExpirationDate] ExchangeRawCategoryEnum.okxFutures splitSymbol.length != 5인 경우 발생');
          break;
        }

      case ExchangeRawCategoryEnum.binanceCm:
        return splitSymbol.last == 'PERP' ? '' : '20${splitSymbol.last}';

      default:
        break;
    }
    return ''; // 모든 PERP인 경우 처리
  }
}

class TickerInfoModelAdapter extends TypeAdapter<TickerInfoModel> {
  @override
  final int typeId = 2; // 타입 식별자입니다.

  @override
  TickerInfoModel read(BinaryReader reader) {
    // 바이너리 데이터를 읽어 TickerInfoModel 객체를 생성합니다.
    return TickerInfoModel(
      tickerId: reader.readString(),
      rawSymbol: reader.readString(),
      symbolSub: reader.readString(),
      unit: reader.readInt(),
      strikePrice: reader.readString(),
      optionTypeEnum: OptionTypeEnum.values[reader.readInt()],
      expirationDate: reader.readString(),
      baseCode: reader.readString(),
      quoteCode: reader.readString(),
      paymentCode: reader.readString(),
      baseCodeKorean: reader.readString(),
      quoteCodeKorean: reader.readString(),
      paymentCodeKorean: reader.readString(),
      baseGroup: reader.readString(),
      quoteGroup: reader.readString(),
      paymentGroup: reader.readString(),
      baseGroupKorean: reader.readString(),
      quoteGroupKorean: reader.readString(),
      paymentGroupKorean: reader.readString(),
      baseCountry: reader.readString(),
      quoteCountry: reader.readString(),
      paymentCountry: reader.readString(),
      baseCountryKorean: reader.readString(),
      quoteCountryKorean: reader.readString(),
      paymentCountryKorean: reader.readString(),
      rawCategory: reader.readString(),
      category: reader.readString(),
      exchangeRawCategoryEnum: ExchangeRawCategoryEnum.values[reader.readInt()],
      categoryExchangeEnum: CategoryExchangeEnum.values[reader.readInt()],
      source: reader.readString(),
      remark: reader.readString(),
      searchKeywords: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, TickerInfoModel obj) {
    // TickerInfoModel 객체를 바이너리 데이터로 씁니다.
    writer.writeString(obj.tickerId);
    writer.writeString(obj.rawSymbol);
    writer.writeString(obj.symbolSub);
    writer.writeInt(obj.unit);
    writer.writeString(obj.strikePrice);
    writer.writeInt(obj.optionTypeEnum.index);
    writer.writeString(obj.expirationDate);
    writer.writeString(obj.baseCode);
    writer.writeString(obj.quoteCode);
    writer.writeString(obj.paymentCode);
    writer.writeString(obj.baseCodeKorean);
    writer.writeString(obj.quoteCodeKorean);
    writer.writeString(obj.paymentCodeKorean);
    writer.writeString(obj.baseGroup);
    writer.writeString(obj.quoteGroup);
    writer.writeString(obj.paymentGroup);
    writer.writeString(obj.baseGroupKorean);
    writer.writeString(obj.quoteGroupKorean);
    writer.writeString(obj.paymentGroupKorean);
    writer.writeString(obj.baseCountry);
    writer.writeString(obj.quoteCountry);
    writer.writeString(obj.paymentCountry);
    writer.writeString(obj.baseCountryKorean);
    writer.writeString(obj.quoteCountryKorean);
    writer.writeString(obj.paymentCountryKorean);
    writer.writeString(obj.rawCategory);
    writer.writeString(obj.category);
    writer.writeInt(obj.exchangeRawCategoryEnum.index);
    writer.writeInt(obj.categoryExchangeEnum.index);
    writer.writeString(obj.source);
    writer.writeString(obj.remark);
    writer.writeString(obj.searchKeywords);
  }
}
