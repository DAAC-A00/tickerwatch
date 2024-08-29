// ticker_info_model.dart

import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:tickerwatch/external/default/exchange_raw_category_enum.dart';
import 'package:tickerwatch/product/tickers/enums/option_type_enum.dart';

import '../enums/category_enum.dart';
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
  String baseCode; // PEPE_0
  String quoteCode; // USDC_0
  String paymentCode; // USDC_0
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
  CategoryEnum categoryEnum;
  final ExchangeRawCategoryEnum exchangeRawCategoryEnum; // 정보 공유자
  CategoryExchangeEnum categoryExchangeEnum;
  String source; // 정보 출처

  // etc
  final String remark;
  final String searchKeywords;

  List<String> splitSymbol = [];

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
    required this.categoryEnum,
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
    rawSymbol = rawSymbol;
    late String tmpSymbol;

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
    //    bitget spot : BTCUSDT, PEPEEUR, USDTBRL
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
    //    bybit spot : length 1 -> ['BTCBRL'], ['PEPEUSDC'], ['DOGEEUR'], ['1SOLUSDT'], ['1INCHUSDT']
    //    bybit linear : length 1 /// 2 유기한 -> ['10000000AIDOGEUSDT'], ['1000000PEIPEIUSDT'], ['10000COQUSDT'], ['SHIB1000PERP'], ['BTCPERP'] /// ['BTC', '06SEP24'], ['BTC', '25OCT24'], ['BTC', '27DEC24'], ['BTC', '27JUN25'], ['BTC', '27SEP24'], ['BTC', '28MAR25'], ['BTC', '30AUG24']
    //    bybit inverse : length 1 -> ['BTCUSDZ24'], ['BTCUSDU24'], ['DOTUSD']
    //    bitget spot : length 1 -> ['BTCUSDT'], ['PEPEEUR'], ['USDTBRL']
    //    bitget umcbl : length 1 -> ['BTCUSDT']
    //    bitget dmcbl : length 1 /// 2 유기한 -> ['BTCUSD'] /// ['ETHUSD', '240927']
    //    bitget cmcbl : length 1 -> ['ETHPERP']
    //    okx SPOT : length 2 -> ['BTC', 'USDT']
    //    okx SWAP : length 2 -> ['BTC', 'USD'], ['ETH', 'USDC']
    //    okx FUTURES : length 3 유기한 -> ['XRP', 'USDT', '241227']
    //    okx OPTION : length 5 유기한 -> ['BTC', 'USD', '240906', '62000', 'P'], ['BTC', 'USD', '241108', '50000', 'C']
    //    binance spot : length 1 -> ['BNBETH'], ['ETHUSDT'], ['1000SATSTRY'], ['1000SATSFDUSD']
    //    binance cm : length 2 무/유기한 -> ['ETHUSD', '240927'], ['ETHUSD', 'PERP'], ['UNIUSD', 'PERP'], ['LTCUSD', '241227']
    //    binance um : length 1 /// 2 유기한 -> ['BTCUSDC'], ['1000PEPEUSDT'], ['1000SHIBUSDC'] /// ['BTCUSDT', '241227']
    //    upbit spot : length 2 -> ['KRW', 'BTC'], ['USDT', 'BTC'], ['BTC', 'APE']       (quoteCode-baseCode)
    //    bithumb spot : length 1 -> ['BTC'], ['ETH']

    expirationDate =
        _getExpirationDateAndUpdateOptionData(exchangeRawCategoryEnum);

    // category & source
    switch (exchangeRawCategoryEnum) {
      case ExchangeRawCategoryEnum.bybitSpot:
        categoryExchangeEnum = CategoryExchangeEnum.spotBybit;
        categoryEnum = CategoryEnum.spot;
        source = 'bybit';
        break;
      case ExchangeRawCategoryEnum.bitgetSpot:
        categoryExchangeEnum = CategoryExchangeEnum.spotBitget;
        categoryEnum = CategoryEnum.spot;
        source = 'bitget';
        break;
      case ExchangeRawCategoryEnum.okxSpot:
        categoryExchangeEnum = CategoryExchangeEnum.spotOkx;
        categoryEnum = CategoryEnum.spot;
        source = 'okx';
        break;
      case ExchangeRawCategoryEnum.binanceSpot:
        categoryExchangeEnum = CategoryExchangeEnum.spotBinance;
        categoryEnum = CategoryEnum.spot;
        source = 'binance';
        break;
      case ExchangeRawCategoryEnum.upbitSpot:
        categoryExchangeEnum = CategoryExchangeEnum.spotUpbit;
        categoryEnum = CategoryEnum.spot;
        source = 'upbit';
        break;
      case ExchangeRawCategoryEnum.bithumbSpot:
        categoryExchangeEnum = CategoryExchangeEnum.spotBithumb;
        categoryEnum = CategoryEnum.spot;
        source = 'bithumb';
        break;
      case ExchangeRawCategoryEnum.bybitLinear:
        categoryExchangeEnum = CategoryExchangeEnum.umBybit;
        categoryEnum = CategoryEnum.um;
        source = 'bybit';
        break;
      case ExchangeRawCategoryEnum.bitgetUmcbl:
      case ExchangeRawCategoryEnum.bitgetCmcbl:
        categoryExchangeEnum = CategoryExchangeEnum.umBitget;
        categoryEnum = CategoryEnum.um;
        source = 'bitget';
        break;
      case ExchangeRawCategoryEnum.okxSwap:
        source = 'okx';
        if (splitSymbol.last == 'USD') {
          categoryExchangeEnum = CategoryExchangeEnum.cmOkx;
          categoryEnum = CategoryEnum.cm;
        } else {
          categoryExchangeEnum = CategoryExchangeEnum.umOkx;
          categoryEnum = CategoryEnum.um;
        }
        break;
      case ExchangeRawCategoryEnum.okxFutures:
        categoryExchangeEnum = CategoryExchangeEnum.umOkx;
        categoryEnum = CategoryEnum.um;
        source = 'okx';
        break;
      case ExchangeRawCategoryEnum.binanceUm:
        categoryExchangeEnum = CategoryExchangeEnum.umBinance;
        categoryEnum = CategoryEnum.um;
        source = 'binance';
        break;
      case ExchangeRawCategoryEnum.bybitInverse:
        categoryExchangeEnum = CategoryExchangeEnum.cmBybit;
        categoryEnum = CategoryEnum.cm;
        source = 'bybit';
        break;
      case ExchangeRawCategoryEnum.bitgetDmcbl:
        categoryExchangeEnum = CategoryExchangeEnum.cmBitget;
        categoryEnum = CategoryEnum.cm;
        source = 'bitget';
        break;
      case ExchangeRawCategoryEnum.binanceCm:
        categoryExchangeEnum = CategoryExchangeEnum.cmBinance;
        categoryEnum = CategoryEnum.cm;
        source = 'binance';
        break;
      case ExchangeRawCategoryEnum.okxOption:
        categoryExchangeEnum = CategoryExchangeEnum.cmOptionOkx;
        categoryEnum = CategoryEnum.option;
        source = 'option';
        break;
    }

    // splitSymbol 예시
    //    bybit spot : length 1 -> ['BTCBRL'], ['PEPEUSDC'], ['DOGEEUR'], ['1SOLUSDT'], ['1INCHUSDT']
    //    bybit linear : length 1 /// 2 유기한 -> ['10000000AIDOGEUSDT'], ['1000000PEIPEIUSDT'], ['10000COQUSDT'], ['SHIB1000PERP'], ['BTCPERP'] /// ['BTC'], ['BTC'], ['BTC'], ['BTC'], ['BTC'], ['BTC'], ['BTC']
    //    bybit inverse : length 1 -> ['BTCUSD'], ['BTCUSD'], ['DOTUSD']
    //    bitget spot : length 1 -> ['BTCUSDT'], ['PEPEEUR'], ['USDTBRL']
    //    bitget umcbl : length 1 -> ['BTCUSDT']
    //    bitget dmcbl : length 1 /// 2 유기한 -> ['BTCUSD'] /// ['ETHUSD']
    //    bitget cmcbl : length 1 -> ['ETHPERP']
    //    okx SPOT : length 2 -> ['BTC', 'USDT']
    //    okx SWAP : length 2 -> ['BTC', 'USD'], ['ETH', 'USDC']
    //    okx FUTURES : length 3 유기한 -> ['XRP', 'USDT']
    //    okx OPTION : length 5 유기한 -> ['BTC', 'USD'], ['BTC', 'USD']
    //    binance spot : length 1 -> ['BNBETH'], ['ETHUSDT'], ['1000SATSTRY'], ['1000SATSFDUSD']
    //    binance cm : length 2 무/유기한 -> ['ETHUSD'], ['ETHUSD'], ['UNIUSD'], ['LTCUSD']
    //    binance um : length 1 /// 2 유기한 -> ['BTCUSDC'], ['1000PEPEUSDT'], ['1000SHIBUSDC'] /// ['BTCUSDT']
    //    upbit spot : length 2 -> ['KRW', 'BTC'], ['USDT', 'BTC'], ['BTC', 'APE']       (quoteCode-baseCode)
    //    bithumb spot : length 1 -> ['BTC'], ['ETH']

    // TODO quoteCode 분리
    late String unitAndBaseCode;
    switch (exchangeRawCategoryEnum) {
      case ExchangeRawCategoryEnum.upbitSpot:
        unitAndBaseCode = splitSymbol.last;
        quoteCode = splitSymbol.first;
        break;
      case ExchangeRawCategoryEnum.bithumbSpot:
        unitAndBaseCode = splitSymbol.first;
        quoteCode = subData ?? '';
        break;
      case ExchangeRawCategoryEnum.okxSpot:
      case ExchangeRawCategoryEnum.okxSwap:
      case ExchangeRawCategoryEnum.okxFutures:
      case ExchangeRawCategoryEnum.okxOption:
        unitAndBaseCode = splitSymbol.first;
        quoteCode = splitSymbol.last;
        break;
      default:
        if (splitSymbol.first.length > 5) {
          final String suffix5 =
              splitSymbol.first.substring(splitSymbol.first.length - 5);
          if (['BUSDS', 'FDUSD'].contains(suffix5)) {
            quoteCode = suffix5;
            unitAndBaseCode =
                splitSymbol.first.substring(0, splitSymbol.first.length - 5);
          }
        }
        if (splitSymbol.first.length > 4) {
          final String suffix4 =
              splitSymbol.first.substring(splitSymbol.first.length - 4);
          if (splitSymbol.first ==
                  'DOTUSD' // DOT USD로 나뉘어야하는데, 해당 로직에서 DO TUSD로 잘못 나뉘는 문제가 있어 제외하고 진행
              &&
              [
                // coin
                'DOGE', //
                // $
                'TUSD',
                'USDT',
                'USDC',
                'PERP'
                    'USDP', // = PAX
                // fiat
                'BKRW',
                'BIDR',
                'IDRT',
                'BVND',
                'AEUR', // Anchored Coins EUR
                'USDS', // United States Digital Service
                'USDE' // 에테나(Ethena) : 이더리움 기반 담보형 합성 스테이블코인 프로토콜 = ETH를 예치하면 자동으로 현물 + 숏 포지션으로 이루어진 합성 포지션이 구축되고 동일한 가치의 USDe를 받도록 설계
              ].contains(suffix4)) {
            quoteCode =
                suffix4 == 'PERP' ? 'USDC' : suffix4; // PERP인 경우 USDC로 변경
            unitAndBaseCode =
                splitSymbol.first.substring(0, splitSymbol.first.length - 4);
          }
        }
        if (splitSymbol.first.length > 3) {
          final String suffix3 =
              splitSymbol.first.substring(splitSymbol.first.length - 3);
          if ([
            // coin
            'BTC',
            'ETH',
            'XRP',
            'UST', // 루나 USD
            'BNB',
            'TRX', // 트론
            'DOT',
            'BRZ', // Brazilian Digital Token = 브라질 헤알과 1:1 페깅을 유지하도록 설계된 이더리움 블록체인 위에 구축된 ERC-20 토큰
            // $
            'USD',
            'DAI',
            'PAX', // = USDP
            'VAI',
            // fiat
            'NGN', // 나이지리아 Nigerian - 나이라 Naira
            'TRY', // 터키 - 리라
            'ARS', // 아르헨티나 Argentine - 페소 Peso
            'EUR', // 유럽연합 - 유로
            'AUD', // 호주 - 달러
            'GBP', // 영국 - 파운드
            'BRL', // 브라질 - 레알
            'PLN', // 폴란드 - 즐로티
            'RUB', // 러시아 - 루블
            'RON', // 루마니아 - 레우
            'ZAR', // 남아프리카 공화국 - 랜드
            'UAH', // 우크라이나 Ukrainian - 흐리브냐 Hryvnia
            'JPY', // 일본 Japan - 엔
            'MXN', // 멕시코 페소
            'CZK', // 체코 코루나
            'COP', // 콜롬비아 COLUMBIA - 페소
          ].contains(suffix3)) {
            quoteCode = suffix3;
            unitAndBaseCode =
                splitSymbol.first.substring(0, splitSymbol.first.length - 3);
          }
        } else {}
        break;
    }

    // TODO unit & baseCode 분리

    // TODO paymentCode
    if (splitSymbol.last == 'USD') {
      paymentCode = baseCode;
    } else {
      paymentCode = quoteCode;
    }

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

  void _updateStrikePrice() {
    strikePrice = splitSymbol.last;
    _popSplitSymbol;
  }

  void _updateOptionType() {
    if (splitSymbol.last == 'C') {
      optionTypeEnum = OptionTypeEnum.call;
      _popSplitSymbol;
    } else if (splitSymbol.last == 'P') {
      optionTypeEnum = OptionTypeEnum.put;
      _popSplitSymbol;
    } else {
      log('[WARN][TickerInfoModel._updateOptionType] Invalid option type detected: ${splitSymbol.last}. Setting to OptionTypeEnum.none');
      optionTypeEnum = OptionTypeEnum.none;
    }
  }

  String _getExpirationDateAndUpdateOptionData(
      ExchangeRawCategoryEnum exchangeRawCategoryEnum) {
    switch (exchangeRawCategoryEnum) {
      case ExchangeRawCategoryEnum.bybitLinear:
        if (splitSymbol.length == 2) {
          return _extractExpirationDate(_popSplitSymbol() ?? '');
        }
        break;
      case ExchangeRawCategoryEnum.bybitInverse:
        if (splitSymbol.first.substring(3) == 'Z24') {
          splitSymbol.first =
              splitSymbol.first.substring(0, splitSymbol.first.length - 3);
          return '20241227';
        } else if (splitSymbol.first.substring(3) == 'U24') {
          splitSymbol.first =
              splitSymbol.first.substring(0, splitSymbol.first.length - 3);
          return '20240927';
        } else {
          return '';
        }

      case ExchangeRawCategoryEnum.bitgetDmcbl:
      case ExchangeRawCategoryEnum.binanceUm:
        if (splitSymbol.length == 2) {
          return '20$_popSplitSymbol';
        }
        break;

      case ExchangeRawCategoryEnum.okxFutures:
        final String partOfExpirationDate = _popSplitSymbol() ?? '';
        return '20$partOfExpirationDate';
      case ExchangeRawCategoryEnum.okxOption:
        if (splitSymbol.length == 5) {
          _updateOptionType();
          _updateStrikePrice();
          return _popSplitSymbol() ?? '';
        } else {
          log('[WARN][TickerInfoModel._getExpirationDateAndUpdateOptionData] ExchangeRawCategoryEnum.okxFutures splitSymbol.length != 5인 경우 발생');
          break;
        }

      case ExchangeRawCategoryEnum.binanceCm:
        return splitSymbol.last == 'PERP' ? '' : '20$_popSplitSymbol';

      default:
        break;
    }
    return ''; // 모든 PERP인 경우 처리
  }

  String? _popSplitSymbol() {
    // python에서 pop은 해당 List의 마지막 요소를 remove하면서 return하는 기본함수이다.
    return splitSymbol.isNotEmpty ? splitSymbol.removeLast() : null;
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
      categoryEnum: CategoryEnum.values[reader.readInt()],
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
    writer.writeInt(obj.categoryEnum.index);
    writer.writeInt(obj.exchangeRawCategoryEnum.index);
    writer.writeInt(obj.categoryExchangeEnum.index);
    writer.writeString(obj.source);
    writer.writeString(obj.remark);
    writer.writeString(obj.searchKeywords);
  }
}
