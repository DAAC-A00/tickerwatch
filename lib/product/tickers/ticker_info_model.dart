// ticker_info_model.dart

import 'package:tickerwatch/external/default/exchange_raw_category_enum.dart';

import 'category_exchange_enum.dart';

class TickerInfoModel {
  // TickerInfoModel
  // symbol
  final String? rawSymbol;
  final String? symbolSub;
  final int unit;
  // Codes
  final String baseCode;
  final String quoteCode;
  final String paymentCode;
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
  final String? rawCategory;
  final String category;
  final ExchangeRawCategoryEnum exchangeRawCategoryEnum;
  final CategoryExchangeEnum categoryExchangeEnum;
  final String? source;

  // searchKeywords
  final String searchKeywords;

  // TickerInfoModel 아닐수도 있는 것
  final String? expirationDate;

  TickerInfoModel(
      // raw
      {required this.rawSymbol,
      required this.symbolSub,
      required this.unit,
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
      required this.searchKeywords,
      this.expirationDate});
}
