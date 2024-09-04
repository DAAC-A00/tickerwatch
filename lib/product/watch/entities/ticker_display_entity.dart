// ticker_display_entity.dart

import 'package:tickerwatch/external/default/exchange_raw_category_enum.dart';
import 'package:tickerwatch/product/tickers/enums/category_exchange_enum.dart';
import 'package:hive/hive.dart';

class TickerDisplayEntity {
  // 이용자 선택 또는 입력
  CategoryExchangeEnum categoryExchangeEnum;
  String name;
  String price;
  // 자동 세팅 - tickerDisplay data
  bool isUp;
  // 자동 세팅 -
  ExchangeRawCategoryEnum exchangeRawCategoryEnum;
  String rawSymbol;

  TickerDisplayEntity({
    required this.categoryExchangeEnum,
    required this.name,
    required this.price,
    required this.isUp,
    required this.exchangeRawCategoryEnum,
    required this.rawSymbol,
  });
}

class TickerDisplayEntityAdapter extends TypeAdapter<TickerDisplayEntity> {
  @override
  final typeId = 4;

  @override
  TickerDisplayEntity read(BinaryReader reader) {
    final categoryExchangeEnum = reader.read() as CategoryExchangeEnum;
    final name = reader.readString();
    final price = reader.readString();
    final isUp = reader.readBool();
    final exchangeRawCategoryEnum = reader.read() as ExchangeRawCategoryEnum;
    final rawSymbol = reader.readString();

    return TickerDisplayEntity(
      categoryExchangeEnum: categoryExchangeEnum,
      name: name,
      price: price,
      isUp: isUp,
      exchangeRawCategoryEnum: exchangeRawCategoryEnum,
      rawSymbol: rawSymbol,
    );
  }

  @override
  void write(BinaryWriter writer, TickerDisplayEntity obj) {
    writer.write(obj.categoryExchangeEnum);
    writer.writeString(obj.name);
    writer.writeString(obj.price);
    writer.writeBool(obj.isUp);
    writer.write(obj.exchangeRawCategoryEnum);
    writer.writeString(obj.rawSymbol);
  }
}
