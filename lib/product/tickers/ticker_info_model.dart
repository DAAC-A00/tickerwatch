import 'package:tickerwatch/external/default/exchange_raw_category_enum.dart';

import 'category_exchange_enum.dart';

class TickerInfoModel {
  // TickerInfoModel
  // raw
  final String? rawSymbol,
      rawCategory,
      // code
      baseCode,
      quoteCode,
      paymentCode,
      baseCodeKorean,
      quoteCodeKorean,
      paymentCodeKorean,
      // group
      baseGroup,
      quoteGroup,
      paymentGroup,
      baseGroupKorean,
      quoteGroupKorean,
      paymentGroupKorean,
      // country
      baseCountry,
      quoteCountry,
      paymentCountry,
      baseCountryKorean,
      quoteCountryKorean,
      paymentCountryKorean,
      // category
      category;
  final ExchangeRawCategoryEnum exchangeRawCategoryEnum;
  final CategoryExchangeEnum categoryExchangeEnum;
  // searchKeywords
  final String searchKeywords;
  // unit
  final int unit;

  // TickerInfoModel 아닐수도 있는 것
  final String? expirationDate;

  TickerInfoModel(
      {required this.rawSymbol,
      required this.rawCategory,
      required this.baseCodeKorean,
      required this.quoteCodeKorean,
      required this.paymentCodeKorean,
      required this.baseGroupKorean,
      required this.quoteGroupKorean,
      required this.paymentGroupKorean,
      required this.baseCountry,
      required this.quoteCountry,
      required this.paymentCountry,
      required this.baseCountryKorean,
      required this.quoteCountryKorean,
      required this.paymentCountryKorean,
      required this.category,
      required this.exchangeRawCategoryEnum,
      required this.categoryExchangeEnum,
      required this.searchKeywords,
      required this.paymentCode,
      required this.baseGroup,
      required this.quoteGroup,
      required this.paymentGroup,
      required this.unit,
      required this.baseCode,
      required this.quoteCode,
      this.expirationDate});
}
