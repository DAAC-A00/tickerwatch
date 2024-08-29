// ticker_info_model.dart

import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:tickerwatch/external/default/exchange_raw_category_enum.dart';
import 'package:tickerwatch/product/tickers/enums/option_type_enum.dart';

import '../enums/category_enum.dart';
import '../enums/category_exchange_enum.dart';

class TickerInfoModel {
  // // tickerId : 현물,무기한 baseCode/quoteCode=paymentCode & 유기한 baseCode/quoteCode=paymentCode-expiration
  // //    무기한 상품 고유값 ex1 : BTC_0/USDT_0
  // //    무기한 상품 고유값 ex2 : BTC_1/KRW_0
  // //    만기 있는 상품 고유값 : BTC_0/USDT_0-20241220
  // final String tickerId;
  // symbol
  final String rawSymbol; // 1000PEPEPERP
  final String symbolSub; // PERP
  int unit; // 1000

  // option 관련
  OptionTypeEnum optionTypeEnum; // 옵션 종류
  String strikePrice; // 행사 가격
  String expirationDate; // 행사일

  // Codes
  String baseCode; // PEPE_0
  String quoteCode; // USDC_0
  String paymentCode; // USDC_0
  String baseCodeKorean;
  String quoteCodeKorean;
  String paymentCodeKorean;

  // Groups
  String baseGroup;
  String quoteGroup;
  String paymentGroup;
  String baseGroupKorean;
  String quoteGroupKorean;
  String paymentGroupKorean;

  // Countries
  String baseCountry;
  String quoteCountry;
  String paymentCountry;
  String baseCountryKorean;
  String quoteCountryKorean;
  String paymentCountryKorean;

  // category
  CategoryEnum categoryEnum;
  final ExchangeRawCategoryEnum exchangeRawCategoryEnum; // 정보 공유자
  CategoryExchangeEnum categoryExchangeEnum;
  String source; // 정보 출처

  // etc
  String remark;
  String searchKeywords;

  List<String> splitSymbol = [];

  TickerInfoModel({
    // required this.tickerId,
    // raw
    required this.rawSymbol,
    this.symbolSub = '',
    this.unit = 1,
    // option 관련
    this.optionTypeEnum = OptionTypeEnum.none,
    this.strikePrice = '',
    this.expirationDate = '',
    // Code
    this.baseCode = '',
    this.quoteCode = '',
    this.paymentCode = '',
    this.baseCodeKorean = '',
    this.quoteCodeKorean = '',
    this.paymentCodeKorean = '',
    // Group
    this.baseGroup = '',
    this.quoteGroup = '',
    this.paymentGroup = '',
    this.baseGroupKorean = '',
    this.quoteGroupKorean = '',
    this.paymentGroupKorean = '',
    // Country
    this.baseCountry = '',
    this.quoteCountry = '',
    this.paymentCountry = '',
    this.baseCountryKorean = '',
    this.quoteCountryKorean = '',
    this.paymentCountryKorean = '',
    // category
    this.categoryEnum = CategoryEnum.none,
    this.exchangeRawCategoryEnum = ExchangeRawCategoryEnum.none,
    this.categoryExchangeEnum = CategoryExchangeEnum.none,
    this.source = '',
    this.remark = '',
    this.searchKeywords = '',
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

  void rawToTickerInfo({String? subData, bool isPreferToFiat = false}) {
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
      case ExchangeRawCategoryEnum.none:
        break;
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

    // quoteCode 분리
    late String unitAndBaseCode;
    switch (exchangeRawCategoryEnum) {
      case ExchangeRawCategoryEnum.upbitSpot:
        unitAndBaseCode = splitSymbol.last;
        quoteCode = '${splitSymbol.first}_0';
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
        quoteCode = '${splitSymbol.last}_0';
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
                'USDC', 'PERP',
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
            quoteCode = suffix4 == 'PERP'
                ? 'USDC_0'
                : '${suffix4}_0'; // PERP인 경우 USDC로 변경
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
            quoteCode = '${suffix3}_0';
            unitAndBaseCode =
                splitSymbol.first.substring(0, splitSymbol.first.length - 3);
          } else {
            // 분리가 안되는 경우
            quoteCode = '';
            unitAndBaseCode = '';
            log('[WARN][TickerInfoModel.rawToTickerInfo] quoteCode 분리 실패. 확인 요망 - $exchangeRawCategoryEnum $rawSymbol');
          }
        }
        break;
    }

    // unit & baseCode 분리
    _updateUnitAndBaseCode(unitAndBaseCode);

    // paymentCode
    if (splitSymbol.last == 'USD') {
      paymentCode = baseCode;
    } else {
      paymentCode = quoteCode;
    }

    baseCodeKorean = _getCodeKorean(baseCode);
    quoteCodeKorean = _getCodeKorean(quoteCode);
    paymentCodeKorean = _getCodeKorean(paymentCode);
    baseGroup = _getGroup(baseCode);
    quoteGroup = _getGroup(quoteCode);
    paymentGroup = _getGroup(paymentCode);
    baseGroupKorean = _getGroupKorean(baseGroup);
    quoteGroupKorean = _getGroupKorean(quoteGroup);
    paymentGroupKorean = _getGroupKorean(paymentGroup);
    baseCountry = _getCountryEnglish(baseCode);
    quoteCountry = _getCountryEnglish(quoteCode);
    paymentCountry = _getCountryEnglish(paymentCode);
    baseCountryKorean = _getCountryKorean(baseCode);
    quoteCountryKorean = _getCountryKorean(quoteCode);
    paymentCountryKorean = _getCountryKorean(paymentCode);

    searchKeywords =
        '$rawSymbol$unit${baseCode.split('_').first}$unit${quoteCode.split('_').first}${baseCode.split('_').first}${paymentCode.split('_').first}$baseCodeKorean$quoteCodeKorean$paymentCodeKorean${exchangeRawCategoryEnum.name}${categoryEnum.name}$baseGroup$quoteGroup$paymentGroup$baseGroupKorean$quoteCodeKorean$paymentCodeKorean$baseCountry$quoteCountry$paymentCountry$baseCountryKorean$quoteCountryKorean$paymentCountryKorean';

    // TODO 이어서 데이터 가공 로직 구현 필요
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

  void _updateUnitAndBaseCode(String unitAndBaseCode) {
    // 유효한 unit 값들을 정의합니다.
    final List<int> validUnits = [
      100,
      1000,
      10000,
      100000,
      1000000,
      10000000,
      100000000,
      1000000000,
      10000000000,
    ];

    if (unitAndBaseCode.isEmpty) {
      unit = 1;
      baseCode = '';
    } else {
      // baseCode를 숫자와 나머지 부분으로 나누기 위한 정규 표현식입니다.
      RegExp regExp = RegExp(r'^(\d+)([A-Za-z0-9]*)$');
      Match? match = regExp.firstMatch(unitAndBaseCode);

      if (match != null) {
        final int? possibleUnit = int.tryParse(match.group(1)!);
        final String? remainingPart = match.group(2);

        if (possibleUnit != null && validUnits.contains(possibleUnit)) {
          // possibleUnit이 유효한 unit 값 중 하나인 경우
          unit = possibleUnit;
          baseCode = remainingPart != null ? '${remainingPart}_0' : '';
        } else {
          // 유효한 unit 값이 아닌 경우, 전체 baseCode를 code로 간주합니다.
          unit = 1;
          baseCode = unitAndBaseCode.isNotEmpty ? '${unitAndBaseCode}_0' : '';
        }
      }
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

String _getGroup(String? code, {bool isPreferToFiat = false}) {
  switch (code) {
    // 법정화폐
    case 'KRW' ||
          'USD' ||
          'EUR' ||
          'JPY' ||
          'GBP' ||
          'CHF' ||
          'CAD' ||
          'AUD' ||
          'CNY' ||
          'HKD' ||
          'SEK' ||
          'NZD' ||
          'SGD' ||
          'NOK' ||
          'MXN' ||
          'INR' ||
          'RUB' ||
          'ZAR' ||
          'TRY' ||
          'BRL' ||
          'AED' ||
          'BHD' ||
          'BND' ||
          'CNH' ||
          'CZK' ||
          'DKK' ||
          'IDR' ||
          'ILS' ||
          'MYR' ||
          'QAR' ||
          'SAR' ||
          'THB' ||
          'TWD' ||
          'CLP' ||
          'COP' ||
          'EGP' ||
          'HUF' ||
          'KWD' ||
          'OMR' ||
          'PHP' ||
          'PLN' ||
          'PKR' ||
          'RON' ||
          'BDT' ||
          'DZD' ||
          'ETB' ||
          'FJD' ||
          'JOD' ||
          'KES' ||
          'KHR' ||
          'KZT' ||
          'LKR' ||
          'LYD' ||
          'MMK' ||
          'MOP' ||
          'NPR' ||
          'TZS' ||
          'UZS' ||
          'VND' ||
          'AFN' ||
          'ALL' ||
          'AMD' ||
          'ANG' ||
          'AOA' ||
          'ARS' ||
          'AWG' ||
          'AZN' ||
          'BAM' ||
          'BBD' ||
          'BGN' ||
          'BIF' ||
          'BMD' ||
          'BOB' ||
          'BSD' ||
          'BTN' ||
          'BWP' ||
          'BYN' ||
          'BZD' ||
          'CDF' ||
          'CRC' ||
          'CUC' ||
          'CUP' ||
          'CVE' ||
          'DJF' ||
          'DOP' ||
          'ERN' ||
          'FKP' ||
          'GEL' ||
          'GGP' ||
          'GHS' ||
          'GIP' ||
          'GMD' ||
          'GNF' ||
          'GTQ' ||
          'GYD' ||
          'HNL' ||
          'HRK' ||
          'HTG' ||
          'IMP' ||
          'IQD' ||
          'IRR' ||
          'ISK' ||
          'JEP' ||
          'JMD' ||
          'KGS' ||
          'KMF' ||
          'KPW' ||
          'KYD' ||
          'LAK' ||
          'LBP' ||
          'LRD' ||
          'LSL' ||
          'MAD' ||
          'MDL' ||
          'MGA' ||
          'MKD' ||
          'MRU' ||
          'MUR' ||
          'MVR' ||
          'MWK' ||
          'MZN' ||
          'NAD' ||
          'NGN' ||
          'NIO' ||
          'PAB' ||
          'PEN' ||
          'PGK' ||
          'PYG' ||
          'RSD' ||
          'RWF' ||
          'SBD' ||
          'SCR' ||
          'SDG' ||
          'SHP' ||
          'SLL' ||
          'SOS' ||
          'SRD' ||
          'SSP' ||
          'STD' ||
          'STN' ||
          'SVC' ||
          'SYP' ||
          'SZL' ||
          'TJS' ||
          'TMT' ||
          'TND' ||
          'TOP' ||
          'TTD' ||
          'UAH' ||
          'UGX' ||
          'UYU' ||
          'VES' ||
          'VUV' ||
          'WST' ||
          'XAF' ||
          'XCD' ||
          'XOF' ||
          'YER' ||
          'ZMW' ||
          'ZWL' ||
          'XPF' ||
          'CLF':
      return 'fiat';
    // 원자재
    case 'XPD' || 'XPT' || 'XAG' || 'XAU':
      return 'raw materials';
    // 권리
    case 'XDR':
      return 'rights';
    // 코인
    case 'USDD' ||
          'USDT' ||
          'ID' ||
          'USDC' ||
          'SIS' ||
          'DOT' ||
          'SOL' ||
          'DEVT' ||
          'BLUR' ||
          'SYNR' ||
          'ZEC' ||
          'WOO' ||
          'NEON' ||
          'MCRT' ||
          'INJ' ||
          'STAT' ||
          'HNT' ||
          'LINK2S' ||
          'ETH3L' ||
          'RPL' ||
          'LDO' ||
          'DCR' ||
          'SOLO' ||
          'ATOM' ||
          'SAIL' ||
          'LGX' ||
          'BONK' ||
          'FLOW' ||
          'AGLD' ||
          'BNT' ||
          'NYM' ||
          'SALD' ||
          'HVH' ||
          'TRVL' ||
          'FORT' ||
          'PLT' ||
          'CTT' ||
          'FET' ||
          'MANA' ||
          'XTZ' ||
          'ETH' ||
          'FIDA' ||
          'AFC' ||
          'LFW' ||
          'WEMIX' ||
          'ZEN' ||
          'GENE' ||
          'GGM' ||
          'MATIC' ||
          'SUIA' ||
          'ALGO' ||
          'BTC' ||
          'GSTS' ||
          'TOMI' ||
          'RVN' ||
          'APE' ||
          'ARB' ||
          'SHRAP' ||
          'ADA' ||
          'BTT' ||
          'EOS2L' ||
          'BTC3L' ||
          'PLAY' ||
          'OKG' ||
          'CORE' ||
          'TEL' ||
          'EVER' ||
          'MTC' ||
          'SEOR' ||
          'SWEAT' ||
          'MBX' ||
          'JEFF' ||
          'ZRX' ||
          'ELT' ||
          'QTUM' ||
          'CHZ' ||
          'SPARTA' ||
          'MMC' ||
          'LTC' ||
          'MCT' ||
          'ETC2L' ||
          'GALFT' ||
          'MV' ||
          'OP' ||
          'CYBER' ||
          'BAT' ||
          'CHRP' ||
          'BNB' ||
          'ADA2L' ||
          'SEILOR' ||
          'VEGA' ||
          'XLM' ||
          'XCAD' ||
          'MVL' ||
          'ZTX' ||
          'LEVER' ||
          'SHIB' ||
          'FTM2L' ||
          'GMT2S' ||
          'KLAY' ||
          'GODS' ||
          'TON' ||
          'AVAX' ||
          'GAL' ||
          'SSV' ||
          'BRZ' ||
          'INTER' ||
          'BOBA' ||
          'SAND' ||
          'QMALL' ||
          'CEL' ||
          'VV' ||
          'VINU' ||
          'AGLA' ||
          'APE2S' ||
          'UNI' ||
          'THN' ||
          'WAVES' ||
          'NEXO' ||
          'MELOS' ||
          'RACA' ||
          'AVA' ||
          'POKT' ||
          'FB' ||
          'ICP' ||
          '3P' ||
          'STX' ||
          'BCH' ||
          'NEAR' ||
          'CBX' ||
          'PLY' ||
          'STRM' ||
          'RNDR' ||
          'MOVEZ' ||
          'ORDI' ||
          'COT' ||
          'KAVA' ||
          'GALA' ||
          'WLKN' ||
          'JST' ||
          'KRL' ||
          'ZAM' ||
          'CMP' ||
          'FMB' ||
          'DOGE' ||
          'XRP3S' ||
          'SFUND' ||
          'CRV' ||
          'RSS3' ||
          'DOGE2S' ||
          'PSP' ||
          'XEM' ||
          'LTC2S' ||
          'CTC' ||
          'WLD' ||
          'WBTC' ||
          'KUNCI' ||
          'ACA' ||
          'TRX' ||
          'BEL' ||
          'YFI' ||
          'XEC' ||
          'KAS' ||
          'MEME' ||
          'SCRT' ||
          'ETHW' ||
          'DFI' ||
          'HFT' ||
          'WWY' ||
          'FLR' ||
          'ETH3S' ||
          'PRIME' ||
          'BOB' ||
          'XDC' ||
          'SPELL' ||
          'FIL' ||
          'TUSD' ||
          'KOK' ||
          'DSRUN' ||
          'DYDX' ||
          'PYUSD' ||
          'GMT' ||
          'VELA' ||
          'CULT' ||
          'PEOPLE' ||
          'MTK' ||
          'GM' ||
          'TAP' ||
          'GLMR' ||
          'AGIX' ||
          'TOMS' ||
          'PAXG' ||
          'PSTAKE' ||
          'TRIBE' ||
          'LINK' ||
          'SLG' ||
          'CAPO' ||
          'SUSHI' ||
          'WAXP' ||
          'FTM' ||
          'LADYS' ||
          'FLOKI' ||
          'CAT' ||
          'MAGIC' ||
          'KARATE' ||
          'XAVA' ||
          'MATIC2S' ||
          'FTM2S' ||
          'ENS' ||
          'NEXT' ||
          'ZIL' ||
          'OMN' ||
          'DAI' ||
          'TURBOS' ||
          'GMX' ||
          'DASH' ||
          'AVAX2S' ||
          'KSM' ||
          'XYM' ||
          'DGB' ||
          'DZOO' ||
          'MINA' ||
          'MIX' ||
          'MASK' ||
          'HOT' ||
          'SUI' ||
          'APEX' ||
          'SOS' ||
          'AAVE' ||
          'ENJ' ||
          'INCH' ||
          'KDA' ||
          'AXL' ||
          'CAPS' ||
          'ANKR' ||
          'T' ||
          'ERTHA' ||
          'NESS' ||
          'DOT3S' ||
          'SAITAMA' ||
          'LUNC' ||
          'SAND2S' ||
          'EOS2S' ||
          'MX' ||
          'QNT' ||
          'PEPE2' ||
          'STG' ||
          'DICE' ||
          'HERO' ||
          'XRP' ||
          'DOME' ||
          'CUSD' ||
          'FTT' ||
          'ATOM2S' ||
          'HBAR' ||
          'BABYDOGE' ||
          'SAND2L' ||
          'SHILL' ||
          'XWG' ||
          'APT' ||
          'BICO' ||
          'BTG' ||
          'RAIN' ||
          'MBS' ||
          'ACH' ||
          'ROND' ||
          'RDNT' ||
          'PENDLE' ||
          'W' ||
          'SON' ||
          'GSWIFT' ||
          'ETC' ||
          'ONE' ||
          'IMX' ||
          'JUV' ||
          'MATIC2L' ||
          'ADA2S' ||
          'DOT3L' ||
          'USTC' ||
          'OMG' ||
          'LRC' ||
          'LMWR' ||
          'POL' ||
          'THETA' ||
          'PEPE' ||
          'PERP' ||
          'REAL' ||
          'TWT' ||
          'GPT' ||
          'RUNE' ||
          'ICX' ||
          'ACS' ||
          'BEAM' ||
          'SC' ||
          'OAS' ||
          'KCAL' ||
          'XRP3L' ||
          'LOOKS' ||
          'AVAX2L' ||
          'EGO' ||
          'MIBR' ||
          'CWAR' ||
          'KMON' ||
          'PLANET' ||
          'LTC2L' ||
          'FITFI' ||
          'SEI' ||
          'ROSE' ||
          'FXS' ||
          'VELO' ||
          'ELDA' ||
          'UMA' ||
          'XETA' ||
          'EOS' ||
          'NFT' ||
          'TENET' ||
          'VPAD' ||
          'LING' ||
          'KASTA' ||
          'RLTM' ||
          'SRM' ||
          'BAR' ||
          'EGLD' ||
          'VEXT' ||
          'PTU' ||
          'PIP' ||
          'SIDUS' ||
          'DPX' ||
          'GMT2L' ||
          'LIS' ||
          'FON' ||
          'CANDY' ||
          'HOOK' ||
          'BUSD' ||
          'TIA' ||
          'PUMLX' ||
          'PSG' ||
          'SD' ||
          'ETC2S' ||
          'MOVR' ||
          'SNX' ||
          'TAMA' ||
          'CELO' ||
          'ECOX' ||
          'PPT' ||
          'DEFY' ||
          'CAKE' ||
          'CITY' ||
          'ORT' ||
          'TAVA' ||
          'PRIMAL' ||
          'IZI' ||
          'GNS' ||
          'REN' ||
          'GRT' ||
          'TIME' ||
          'ATOM2L' ||
          'GCAKE' ||
          'DLC' ||
          'AZY' ||
          'MDAO' ||
          'BTC3S' ||
          'APE2L' ||
          'ARKM' ||
          'COMP' ||
          'VRA' ||
          'JASMY' ||
          'RPK' ||
          'KON' ||
          'AGI' ||
          'SUN' ||
          'CO' ||
          'MPLX' ||
          'TOKEN' ||
          'CGPT' ||
          'FAME' ||
          'STETH' ||
          'AXS' ||
          'C98' ||
          'ACM' ||
          'DOGE2L' ||
          'GST' ||
          'AR' ||
          'MKR' ||
          'OBX' ||
          'LINK2L' ||
          'MNZ' ||
          'SLP' ||
          'LUNA' ||
          'MEE' ||
          'SATS' ||
          'STARL' ||
          'AERGO' ||
          'AKRO' ||
          'ALICE' ||
          'ALPACA' ||
          'ALPHA' ||
          'AMB' ||
          'ANT' ||
          'API3' ||
          'ARK' ||
          'ARPA' ||
          'ASTR' ||
          'ATA' ||
          'AUCTION' ||
          'AUDIO' ||
          'BADGER' ||
          'BAKE' ||
          'BAL' ||
          'BAND' ||
          'BIGTIME' ||
          'BLZ' ||
          'BNX' ||
          'BOND' ||
          'BSV' ||
          'BSW' ||
          'CEEK' ||
          'CELR' ||
          'CFX' ||
          'CHR' ||
          'CKB' ||
          'COMBO' ||
          'COTI' ||
          'CRO' ||
          'CTK' ||
          'CTSI' ||
          'CVC' ||
          'CVX' ||
          'DAR' ||
          'DENT' ||
          'DODO' ||
          'DUSK' ||
          'EDU' ||
          'FLM' ||
          'FORTH' ||
          'FRONT' ||
          'GAS' ||
          'GFT' ||
          'GLM' ||
          'GTC' ||
          'HIFI' ||
          'HIGH' ||
          'IDEX' ||
          'ILV' ||
          'IOST' ||
          'IOTA' ||
          'IOTX' ||
          'JOE' ||
          'KEY' ||
          'KNC' ||
          'LINA' ||
          'LIT' ||
          'LOOM' ||
          'LPT' ||
          'LQTY' ||
          'LUNA2' ||
          'MAV' ||
          'MBL' ||
          'MDT' ||
          'MTL' ||
          'MULTI' ||
          'NEO' ||
          'NKN' ||
          'NMR' ||
          'NTRN' ||
          'OCEAN' ||
          'OGN' ||
          'OG' ||
          'ONT' ||
          'ORBS' ||
          'OXT' ||
          'PHB' ||
          'POLYX' ||
          'POWR' ||
          'PROM' ||
          'RAD' ||
          'REEF' ||
          'REQ' ||
          'RIF' ||
          'RLC' ||
          'RSR' ||
          'SFP' ||
          'SKL' ||
          'SNT' ||
          'STEEM' ||
          'STMX' ||
          'STORJ' ||
          'STPT' ||
          'STRAX' ||
          'SXP' ||
          'TLM' ||
          'TRB' ||
          'TRU' ||
          'UNFI' ||
          'VET' ||
          'VGX' ||
          'WSM' ||
          'XCN' ||
          'XMR' ||
          'XNO' ||
          'XVG' ||
          'XVS' ||
          'YFII' ||
          'YGG':
      return 'crypto currency';
    // 법정화폐와 암호화폐 동일한 코드가 있는 경우를 예외처리
    case 'MNT':
      return isPreferToFiat ? 'fiat' : 'crypto currency';
    default:
      return '';
  }
}

// 그룹 한국어 return
String _getGroupKorean(String? group) {
  switch (group) {
    case 'fiat':
      return '법정화폐';
    case 'raw materials':
      return '원자재';
    case 'rights':
      return '권리';
    case 'crypto currency':
      return '암호화폐';
    default:
      return '';
  }
}

// 화폐 단위 한국어 return
String _getCodeKorean(String? code, {bool isPreferToFiat = false}) {
  switch (code) {
    case 'KRW':
      return '원';
    case 'USD':
      return '달러';
    case 'EUR':
      return '유로';
    case 'JPY':
      return '엔';
    case 'GBP':
      return '파운드';
    case 'CHF':
      return '프랑';
    case 'CAD':
      return '달러';
    case 'AUD':
      return '달러';
    case 'CNY':
      return '위안';
    case 'HKD':
      return '달러';
    case 'SEK':
      return '크로나';
    case 'NZD':
      return '달러';
    case 'SGD':
      return '달러';
    case 'NOK':
      return '크로네';
    case 'MXN':
      return '페소';
    case 'INR':
      return '루피';
    case 'RUB':
      return '루블';
    case 'ZAR':
      return '랜드';
    case 'TRY':
      return '리라';
    case 'BRL':
      return '레알';
    case 'AED':
      return '디르함';
    case 'BHD':
      return '디나르';
    case 'BND':
      return '달러';
    case 'CNH':
      return '위안';
    case 'CZK':
      return '코루나';
    case 'DKK':
      return '크로네';
    case 'IDR':
      return '루피아';
    case 'ILS':
      return '셰켈';
    case 'MYR':
      return '링깃';
    case 'QAR':
      return '리알';
    case 'SAR':
      return '리알';
    case 'THB':
      return '밧';
    case 'TWD':
      return '달러';
    case 'CLP':
      return '페소';
    case 'COP':
      return '페소';
    case 'EGP':
      return '파운드';
    case 'HUF':
      return '포린트';
    case 'KWD':
      return '디나르';
    case 'OMR':
      return '리알';
    case 'PHP':
      return '페소';
    case 'PLN':
      return '즐로티';
    case 'PKR':
      return '루피';
    case 'RON':
      return '레우';
    case 'BDT':
      return '타카';
    case 'DZD':
      return '디나르';
    case 'ETB':
      return '비르';
    case 'FJD':
      return '달러';
    case 'JOD':
      return '디나르';
    case 'KES':
      return '실링';
    case 'KHR':
      return '릴';
    case 'KZT':
      return '텡게';
    case 'LKR':
      return '루피';
    case 'LYD':
      return '디나르';
    case 'MMK':
      return '차트';
    case 'MOP':
      return '파타카';
    case 'NPR':
      return '루피';
    case 'TZS':
      return '실링';
    case 'UZS':
      return '쏨';
    case 'VND':
      return '동';
    case 'AFN':
      return '아프가니';
    case 'ALL':
      return '레크(렉)';
    case 'AMD':
      return '드람';
    case 'ANG':
      return '퀄더';
    case 'AOA':
      return '콴자';
    case 'ARS':
      return '페소';
    case 'AWG':
      return '플로린';
    case 'AZN':
      return '마나트';
    case 'BAM':
      return '마르크';
    case 'BBD':
      return '달러';
    case 'BGN':
      return '레프';
    case 'BIF':
      return '프랑';
    case 'BMD':
      return '달러';
    case 'BWP':
      return '풀라';
    case 'BYN':
      return '르블';
    case 'BYR':
      return '르블';
    case 'BZD':
      return '달러';
    case 'CDF':
      return '프랑';
    case 'CRC':
      return '콜론';
    case 'CVE':
      return '에스쿠도';
    case 'DJF':
      return '프랑';
    case 'DOP':
      return '페소';
    case 'ERN':
      return '나크파';
    case 'GEL':
      return '라리';
    case 'GHS':
      return '세디';
    case 'GIP':
      return '파운드';
    case 'GMD':
      return '달라시';
    case 'GNF':
      return '프랑';
    case 'GTQ':
      return '케트살';
    case 'GYD':
      return '달러';
    case 'HNL':
      return '렘피라';
    case 'HRK':
      return '쿠나';
    case 'HTG':
      return '국';
    case 'IQD':
      return '디나르';
    case 'IRR':
      return '리얄';
    case 'ISK':
      return '크로나';
    case 'JEP':
      return '파운드';
    case 'JMD':
      return '달러';
    case 'KGS':
      return '솜';
    case 'KPW':
      return '원';
    case 'KYD':
      return '달러';
    case 'LAK':
      return '킵';
    case 'LBP':
      return '파운드';
    case 'LRD':
      return '달러';
    case 'LSL':
      return '로티';
    case 'LTL':
      return '리타';
    case 'LVL':
      return '라츠';
    case 'MAD':
      return '디르함';
    case 'MDL':
      return '레우';
    case 'MGA':
      return '아리아리';
    case 'MKD':
      return '디나르';
    case 'MNT':
      if (isPreferToFiat) {
        return '투그릭';
      } else {
        return '';
      }
    case 'MRO':
      return '우기야';
    case 'MUR':
      return '루피';
    case 'MVR':
      return '루피야';
    case 'MWK':
      return '콰쳐';
    case 'NAD':
      return '달러';
    case 'NGN':
      return '나이라';
    case 'NIO':
      return '코르도바';
    case 'PAB':
      return '발보아';
    case 'PEN':
      return '누에보솔';
    case 'PGK':
      return '키나';
    case 'RSD':
      return '디나르';
    case 'RWF':
      return '프랑';
    case 'SBD':
      return '달러';
    case 'SCR':
      return '루피';
    case 'SDG':
      return '파운드';
    case 'SHP':
      return '파운드';
    case 'SLL':
      return '레온';
    case 'SOS':
      return '실링';
    case 'SRD':
      return '달러';
    case 'STD':
      return '도브라';
    case 'SZL':
      return '릴랑게니';
    case 'TJS':
      return '소모니';
    case 'TMT':
      return '마나트';
    case 'TND':
      return '디나르';
    case 'TOP':
      return '팡가';
    case 'TTD':
      return '달러';
    case 'TVD':
      return '달러';
    case 'UAH':
      return '프리브나';
    case 'UGX':
      return '실링';
    case 'UYU':
      return '페소';
    case 'VEF':
      return '볼리바르';
    case 'VUV':
      return '바투';
    case 'WST':
      return '탈라';
    case 'XAF':
      return '프랑';
    case 'XCD':
      return '달러';
    case 'XDR':
      return 'SDR';
    case 'XOF':
      return '프랑';
    case 'XPF':
      return '프랑';
    case 'YER':
      return '리알';
    case 'ZMW':
      return '콰쳐';
    case 'ZWD':
      return '달러';
    default:
      return '';
  }
}

// 국가명 한국어 return
String _getCountryKorean(String? code, {bool isPreferToFiat = false}) {
  switch (code) {
    case 'KRW':
      return '대한민국';
    case 'USD':
      return '미국';
    case 'EUR':
      return '유럽연합';
    case 'JPY':
      return '일본';
    case 'GBP':
      return '영국';
    case 'CHF':
      return '스위스';
    case 'CAD':
      return '캐나다';
    case 'AUD':
      return '호주';
    case 'CNY':
      return '중국';
    case 'HKD':
      return '홍콩';
    case 'SEK':
      return '스웨덴';
    case 'NZD':
      return '뉴질랜드';
    case 'SGD':
      return '싱가포르';
    case 'NOK':
      return '노르웨이';
    case 'MXN':
      return '멕시코';
    case 'INR':
      return '인도';
    case 'BRL':
      return '브라질';
    case 'RUB':
      return '러시아';
    case 'ZAR':
      return '남아프리카 공화국';
    case 'TRY':
      return '터키';
    case 'THB':
      return '태국';
    case 'IDR':
      return '인도네시아';
    case 'MYR':
      return '말레이시아';
    case 'ARS':
      return '아르헨티나';
    case 'TWD':
      return '대만';
    case 'AED':
      return '아랍에미리트';
    case 'COP':
      return '콜롬비아';
    case 'PHP':
      return '필리핀';
    case 'VND':
      return '베트남';
    case 'EGP':
      return '이집트';
    case 'ILS':
      return '이스라엘';
    case 'NPR':
      return '네팔';
    case 'PKR':
      return '파키스탄';
    case 'KZT':
      return '카자흐스탄';
    case 'BDT':
      return '방글라데시';
    case 'LKR':
      return '스리랑카';
    case 'KHR':
      return '캄보디아';
    case 'MNT':
      if (isPreferToFiat) {
        return '몽골';
      } else {
        return '';
      }
    case 'MOP':
      return '마카오';
    case 'TJS':
      return '타지키스탄';
    case 'AFN':
      return '아프가니스탄';
    case 'ALL':
      return '알바니아';
    case 'BHD':
      return '바레인';
    case 'BND':
      return '브루나이';
    case 'BWP':
      return '보츠와나';
    case 'BGN':
      return '불가리아';
    case 'BIF':
      return '부룬디';
    case 'BBD':
      return '바베이도스';
    case 'CVE':
      return '카보베르데';
    case 'KYD':
      return '케이맨 제도';
    case 'XAF':
      return '중앙아프리카';
    case 'XOF':
      return '서부아프리카';
    case 'XPF':
      return '프랑스령 폴리네시아';
    case 'XCD':
      return '동카리브';
    case 'CUP':
      return '쿠바';
    case 'DJF':
      return '지부티';
    case 'ERN':
      return '에리트레아';
    case 'ETB':
      return '에티오피아';
    case 'FKP':
      return '포클랜드 제도';
    case 'GEL':
      return '조지아';
    case 'GIP':
      return '지브롤터';
    case 'GMD':
      return '감비아';
    case 'GNF':
      return '기니';
    case 'HTG':
      return '아이티';
    case 'HUF':
      return '헝가리';
    case 'ISK':
      return '아이슬란드';
    case 'IRR':
      return '이란';
    case 'IQD':
      return '이라크';
    case 'JMD':
      return '자메이카';
    case 'JOD':
      return '요르단';
    case 'KES':
      return '케냐';
    case 'KWD':
      return '쿠웨이트';
    case 'KGS':
      return '키르기스스탄';
    case 'LAK':
      return '라오스';
    case 'LBP':
      return '레바논';
    case 'LSL':
      return '레소토';
    case 'LRD':
      return '라이베리아';
    case 'LYD':
      return '리비아';
    case 'MWK':
      return '말라위';
    case 'MVR':
      return '몰디브';
    case 'MRO':
      return '모리타니';
    case 'MUR':
      return '모리셔스';
    case 'MDL':
      return '몰도바';
    case 'MGA':
      return '마다가스카르';
    case 'MMK':
      return '미얀마';
    case 'NAD':
      return '나미비아';
    case 'NGN':
      return '나이지리아';
    case 'OMR':
      return '오만';
    case 'PGK':
      return '파푸아뉴기니';
    case 'PYG':
      return '파라과이';
    case 'PEN':
      return '페루';
    case 'QAR':
      return '카타르';
    case 'RWF':
      return '르완다';
    case 'WST':
      return '사모아';
    case 'SAR':
      return '사우디아라비아';
    case 'SCR':
      return '세이셸';
    case 'SLL':
      return '시에라리온';
    case 'SBD':
      return '솔로몬 제도';
    case 'SOS':
      return '소말리아';
    case 'SSP':
      return '남수단';
    case 'SDG':
      return '수단';
    case 'SRD':
      return '수리남';
    case 'SZL':
      return '스와질란드';
    case 'SYP':
      return '시리아';
    case 'TZS':
      return '탄자니아';
    case 'TTD':
      return '트리니다드토바고';
    case 'UGX':
      return '우간다';
    case 'UAH':
      return '우크라이나';
    case 'UYU':
      return '우루과이';
    case 'UZS':
      return '우즈베키스탄';
    case 'VEF':
      return '베네수엘라';
    case 'YER':
      return '예멘';
    case 'ZMW':
      return '잠비아';
    default:
      return '';
  }
}

// 국가명 영어 return
String _getCountryEnglish(String? code, {bool isPreferToFiat = false}) {
  switch (code) {
    case 'KRW':
      return 'South Korea';
    case 'USD':
      return 'United States';
    case 'EUR':
      return 'European Union';
    case 'JPY':
      return 'Japan';
    case 'GBP':
      return 'United Kingdom';
    case 'CHF':
      return 'Switzerland';
    case 'CAD':
      return 'Canada';
    case 'AUD':
      return 'Australia';
    case 'CNY':
      return 'China';
    case 'HKD':
      return 'Hong Kong';
    case 'SEK':
      return 'Sweden';
    case 'NZD':
      return 'New Zealand';
    case 'SGD':
      return 'Singapore';
    case 'NOK':
      return 'Norway';
    case 'MXN':
      return 'Mexico';
    case 'INR':
      return 'India';
    case 'BRL':
      return 'Brazil';
    case 'RUB':
      return 'Russia';
    case 'ZAR':
      return 'South Africa';
    case 'TRY':
      return 'Turkey';
    case 'THB':
      return 'Thailand';
    case 'IDR':
      return 'Indonesia';
    case 'MYR':
      return 'Malaysia';
    case 'ARS':
      return 'Argentina';
    case 'TWD':
      return 'Taiwan';
    case 'AED':
      return 'United Arab Emirates';
    case 'COP':
      return 'Colombia';
    case 'PHP':
      return 'Philippines';
    case 'VND':
      return 'Vietnam';
    case 'EGP':
      return 'Egypt';
    case 'ILS':
      return 'Israel';
    case 'NPR':
      return 'Nepal';
    case 'PKR':
      return 'Pakistan';
    case 'KZT':
      return 'Kazakhstan';
    case 'BDT':
      return 'Bangladesh';
    case 'LKR':
      return 'Sri Lanka';
    case 'KHR':
      return 'Cambodia';
    case 'MNT':
      return isPreferToFiat ? 'Mongolia' : '';
    case 'MOP':
      return 'Macau';
    case 'TJS':
      return 'Tajikistan';
    case 'AFN':
      return 'Afghanistan';
    case 'ALL':
      return 'Albania';
    case 'BHD':
      return 'Bahrain';
    case 'BND':
      return 'Brunei';
    case 'BWP':
      return 'Botswana';
    case 'BGN':
      return 'Bulgaria';
    case 'BIF':
      return 'Burundi';
    case 'BBD':
      return 'Barbados';
    case 'CVE':
      return 'Cape Verde';
    case 'KYD':
      return 'Cayman Islands';
    case 'XAF':
      return 'Central African Republic';
    case 'XOF':
      return 'West Africa';
    case 'XPF':
      return 'French Polynesia';
    case 'XCD':
      return 'Eastern Caribbean';
    case 'CUP':
      return 'Cuba';
    case 'DJF':
      return 'Djibouti';
    case 'ERN':
      return 'Eritrea';
    case 'ETB':
      return 'Ethiopia';
    case 'FKP':
      return 'Falkland Islands';
    case 'GEL':
      return 'Georgia';
    case 'GIP':
      return 'Gibraltar';
    case 'GMD':
      return 'Gambia';
    case 'GNF':
      return 'Guinea';
    case 'HTG':
      return 'Haiti';
    case 'HUF':
      return 'Hungary';
    case 'ISK':
      return 'Iceland';
    case 'IRR':
      return 'Iran';
    case 'IQD':
      return 'Iraq';
    case 'JMD':
      return 'Jamaica';
    case 'JOD':
      return 'Jordan';
    case 'KES':
      return 'Kenya';
    case 'KWD':
      return 'Kuwait';
    case 'KGS':
      return 'Kyrgyzstan';
    case 'LAK':
      return 'Laos';
    case 'LBP':
      return 'Lebanon';
    case 'LSL':
      return 'Lesotho';
    case 'LRD':
      return 'Liberia';
    case 'LYD':
      return 'Libya';
    case 'MWK':
      return 'Malawi';
    case 'MVR':
      return 'Maldives';
    case 'MRO':
      return 'Mauritania';
    case 'MUR':
      return 'Mauritius';
    case 'MDL':
      return 'Moldova';
    case 'MGA':
      return 'Madagascar';
    case 'MMK':
      return 'Myanmar';
    case 'NAD':
      return 'Namibia';
    case 'NGN':
      return 'Nigeria';
    case 'OMR':
      return 'Oman';
    case 'PGK':
      return 'Papua New Guinea';
    case 'PYG':
      return 'Paraguay';
    case 'PEN':
      return 'Peru';
    case 'QAR':
      return 'Qatar';
    case 'RWF':
      return 'Rwanda';
    case 'WST':
      return 'Samoa';
    case 'SAR':
      return 'Saudi Arabia';
    case 'SCR':
      return 'Seychelles';
    case 'SLL':
      return 'Sierra Leone';
    case 'SBD':
      return 'Solomon Islands';
    case 'SOS':
      return 'Somalia';
    case 'SSP':
      return 'South Sudan';
    case 'SDG':
      return 'Sudan';
    case 'SRD':
      return 'Suriname';
    case 'SZL':
      return 'Eswatini';
    case 'SYP':
      return 'Syria';
    case 'TZS':
      return 'Tanzania';
    case 'TTD':
      return 'Trinidad and Tobago';
    case 'UGX':
      return 'Uganda';
    case 'UAH':
      return 'Ukraine';
    case 'UYU':
      return 'Uruguay';
    case 'UZS':
      return 'Uzbekistan';
    case 'VEF':
      return 'Venezuela';
    case 'YER':
      return 'Yemen';
    case 'ZMW':
      return 'Zambia';
    default:
      return '';
  }
}

class TickerInfoModelAdapter extends TypeAdapter<TickerInfoModel> {
  @override
  final int typeId = 2; // 타입 식별자입니다.

  @override
  TickerInfoModel read(BinaryReader reader) {
    // 바이너리 데이터를 읽어 TickerInfoModel 객체를 생성합니다.
    return TickerInfoModel(
      // tickerId: reader.readString(),
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
    // writer.writeString(obj.tickerId);
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
