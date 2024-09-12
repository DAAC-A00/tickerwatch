// ticker_display_entity.dart

import 'package:tickerwatch/product/tickers/enums/category_exchange_enum.dart';
import 'package:hive/hive.dart';
import 'package:tickerwatch/product/tickers/enums/price_status_enum.dart';

class TickerDisplayEntity {
  // 이용자 선택 또는 입력
  CategoryExchangeEnum categoryExchangeEnum;
  String symbol;
  String price;
  // 자동 세팅 - tickerDisplay data
  PriceStatusEnum priceStatusEnum;
  // 자동 세팅
  DateTime createdAt;
  String searchKeywords;

  TickerDisplayEntity({
    required this.categoryExchangeEnum,
    required this.symbol,
    required this.price,
    required this.priceStatusEnum,
    required this.searchKeywords,
  }) : createdAt = DateTime.now();
}

class TickerDisplayEntityAdapter extends TypeAdapter<TickerDisplayEntity> {
  @override
  final int typeId = 3;

  @override
  TickerDisplayEntity read(BinaryReader reader) {
    final categoryExchangeEnum = CategoryExchangeEnum.values[reader.readInt()];
    final symbol = reader.readString();
    final price = reader.readString();
    final priceStatusEnum = PriceStatusEnum.values[reader.readInt()];
    final searchKeywords = reader.readString();
    final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

    return TickerDisplayEntity(
      categoryExchangeEnum: categoryExchangeEnum,
      symbol: symbol,
      price: price,
      priceStatusEnum: priceStatusEnum,
      searchKeywords: searchKeywords,
    )..createdAt = createdAt;
  }

  @override
  void write(BinaryWriter writer, TickerDisplayEntity obj) {
    writer.writeInt(obj.categoryExchangeEnum.index);
    writer.writeString(obj.symbol);
    writer.writeString(obj.price);
    writer.writeInt(obj.priceStatusEnum.index);
    writer.writeString(obj.searchKeywords);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}
