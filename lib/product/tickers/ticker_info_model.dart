// ticker_info_model.dart

import 'package:hive/hive.dart';
import 'package:tickerwatch/external/default/exchange_raw_category_enum.dart';

import 'category_exchange_enum.dart';

class TickerInfoModel {
  // TickerInfoModel
  // symbol
  final String rawSymbol;
  final String symbolSub;
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
  final String rawCategory;
  final String category;
  final ExchangeRawCategoryEnum exchangeRawCategoryEnum; // 정보 공유자
  final CategoryExchangeEnum categoryExchangeEnum;
  final String source; // 정보 출처

  // etc
  final String remark;
  final String searchKeywords;

  TickerInfoModel({
    // raw
    required this.rawSymbol,
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
    required this.remark,
    required this.searchKeywords,
  });
}

class TickerInfoModelAdapter extends TypeAdapter<TickerInfoModel> {
  @override
  final int typeId = 2; // 타입 식별자입니다.

  @override
  TickerInfoModel read(BinaryReader reader) {
    // 바이너리 데이터를 읽어 TickerInfoModel 객체를 생성합니다.
    return TickerInfoModel(
      rawSymbol: reader.readString(),
      symbolSub: reader.readString(),
      unit: reader.readInt(),
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
    writer.writeString(obj.rawSymbol);
    writer.writeString(obj.symbolSub);
    writer.writeInt(obj.unit);
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
    writer.writeInt(obj.exchangeRawCategoryEnum.index); // Enum 값을 인덱스로 저장
    writer.writeInt(obj.categoryExchangeEnum.index); // Enum 값을 인덱스로 저장
    writer.writeString(obj.source);
    writer.writeString(obj.remark);
    writer.writeString(obj.searchKeywords);
  }
}
