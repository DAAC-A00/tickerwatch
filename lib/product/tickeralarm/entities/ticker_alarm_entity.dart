// ticker_alarm_entity.dart

import 'package:tickerwatch/product/tickers/enums/category_exchange_enum.dart';
import 'package:hive/hive.dart';
import 'package:tickerwatch/product/tickers/enums/price_status_enum.dart';

class TickerAlarmEntity {
  // 이용자 선택 또는 입력
  CategoryExchangeEnum categoryExchangeEnum;
  String symbol;
  String alarmPrice;
  // 자동 세팅 - tickerDisplay data
  PriceStatusEnum priceStatusEnum;
  // 자동 세팅
  DateTime createdAt;
  String searchKeywords;

  TickerAlarmEntity({
    required this.categoryExchangeEnum,
    required this.symbol,
    required this.alarmPrice,
    required this.priceStatusEnum,
    required this.searchKeywords,
  }) : createdAt = DateTime.now();
}

class TickerAlarmEntityAdapter extends TypeAdapter<TickerAlarmEntity> {
  @override
  final int typeId = 3;

  @override
  TickerAlarmEntity read(BinaryReader reader) {
    final categoryExchangeEnum = CategoryExchangeEnum.values[reader.readInt()];
    final symbol = reader.readString();
    final alarmPrice = reader.readString();
    final priceStatusEnum = PriceStatusEnum.values[reader.readInt()];
    final searchKeywords = reader.readString();
    final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

    return TickerAlarmEntity(
      categoryExchangeEnum: categoryExchangeEnum,
      symbol: symbol,
      alarmPrice: alarmPrice,
      priceStatusEnum: priceStatusEnum,
      searchKeywords: searchKeywords,
    )..createdAt = createdAt;
  }

  @override
  void write(BinaryWriter writer, TickerAlarmEntity obj) {
    writer.writeInt(obj.categoryExchangeEnum.index);
    writer.writeString(obj.symbol);
    writer.writeString(obj.alarmPrice);
    writer.writeInt(obj.priceStatusEnum.index);
    writer.writeString(obj.searchKeywords);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}
