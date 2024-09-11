// ticker_display_entity.dart

import 'package:tickerwatch/external/default/exchange_raw_category_enum.dart';
import 'package:tickerwatch/product/tickers/enums/category_exchange_enum.dart';
import 'package:hive/hive.dart';
import 'package:tickerwatch/product/tickers/enums/price_status_enum.dart';

class TickerDisplayEntity {
  // 이용자 선택 또는 입력
  CategoryExchangeEnum categoryExchangeEnum;
  String name;
  String price;
  // 자동 세팅 - tickerDisplay data
  PriceStatusEnum priceStatusEnum;
  // 자동 세팅 -
  ExchangeRawCategoryEnum exchangeRawCategoryEnum;
  String rawSymbol;
  DateTime createdAt;

  TickerDisplayEntity({
    required this.categoryExchangeEnum,
    required this.name,
    required this.price,
    required this.priceStatusEnum,
    required this.exchangeRawCategoryEnum,
    required this.rawSymbol,
  }) : createdAt = DateTime.now();
}

class TickerDisplayEntityAdapter extends TypeAdapter<TickerDisplayEntity> {
  @override
  final int typeId = 3;

  @override
  TickerDisplayEntity read(BinaryReader reader) {
    final categoryExchangeEnum = CategoryExchangeEnum.values[reader.readInt()];
    final name = reader.readString();
    final price = reader.readString();
    final priceStatusEnum = PriceStatusEnum.values[reader.readInt()];
    final exchangeRawCategoryEnum =
        ExchangeRawCategoryEnum.values[reader.readInt()];
    final rawSymbol = reader.readString();
    final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

    return TickerDisplayEntity(
      categoryExchangeEnum: categoryExchangeEnum,
      name: name,
      price: price,
      priceStatusEnum: priceStatusEnum,
      exchangeRawCategoryEnum: exchangeRawCategoryEnum,
      rawSymbol: rawSymbol,
    )..createdAt = createdAt;
  }

  @override
  void write(BinaryWriter writer, TickerDisplayEntity obj) {
    writer.writeInt(obj.categoryExchangeEnum.index);
    writer.writeString(obj.name);
    writer.writeString(obj.price);
    writer.writeInt(obj.priceStatusEnum.index);
    writer.writeInt(obj.exchangeRawCategoryEnum.index);
    writer.writeString(obj.rawSymbol);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}
