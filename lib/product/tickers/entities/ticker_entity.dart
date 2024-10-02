// ticker_entity.dart

import 'package:hive/hive.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_model.dart';

import 'ticker_info_model.dart';

class TickerEntity {
  // -- raw
  final TickerInfoModel info;
  final TickerModel recentData;
  TickerModel? beforeData;
  TickerEntity({
    required this.info,
    required this.recentData,
    this.beforeData,
  });
}

class TickerEntityAdapter extends TypeAdapter<TickerEntity> {
  @override
  final int typeId = 1; // 타입 식별자입니다.

  @override
  TickerEntity read(BinaryReader reader) {
    // 바이너리 데이터를 읽어 TickerEntity 객체를 생성합니다.
    return TickerEntity(
      info: reader.read() as TickerInfoModel,
      recentData: reader.read() as TickerModel,
      beforeData: reader.read() as TickerModel,
    );
  }

  @override
  void write(BinaryWriter writer, TickerEntity obj) {
    // TickerEntity 객체를 바이너리 데이터로 씁니다.
    writer.write(obj.info); // TickerInfoModel을 씁니다.
    writer.write(obj.recentData);
    writer.write(obj.beforeData);
  }
}
