// ticker_model.dart

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../enums/price_status_enum.dart';

class TickerModel {
  // 지속적으로 변하는 데이터
  // -- 현재 호가
  String price; // 현재가 (bidPrice, askPrice의 평균)
  String lastPrice; // 최근 체결가
  String ask1Price;
  String ask1Size;
  String bid1Price;
  String bid1Size;

  // -- 24h
  String changePercent24h;
  String prevPrice24h;
  String highPrice24h;
  String lowPrice24h;
  String turnOver24h; // 거래대금 = quoteCode 기준 거래량
  String volume24h; // 거래량 = baseCode 기준 거래량

  // -- UTC0
  String changePercentUtc0;
  String prevPriceUtc0;
  String highPriceUtc0;
  String lowPriceUtc0;
  String turnOverUtc0; // 거래대금 = quoteCode 기준 거래량
  String volumeUtc0; // 거래량 = baseCode 기준 거래량

  // -- UTC9
  String changePercentUtc9;

  // -- dataAt : 해당 데이터가 타기관에서 기록된 시점
  // -- updatedAt : 해당 데이터가 본 프로그램 내에서 수정된 시점
  late String dataAt;
  late String _updatedAt;
  bool isUpdatedRecently;

  PriceStatusEnum priceStatusEnum; // long, short, stay

  String get updatedAt => _updatedAt;

  TickerModel({
    required this.price,
    this.lastPrice = '',
    this.ask1Price = '',
    this.ask1Size = '',
    this.bid1Price = '',
    this.bid1Size = '',
    this.changePercent24h = '',
    this.prevPrice24h = '',
    this.highPrice24h = '',
    this.lowPrice24h = '',
    this.turnOver24h = '',
    this.volume24h = '',
    this.changePercentUtc0 = '',
    this.prevPriceUtc0 = '',
    this.highPriceUtc0 = '',
    this.lowPriceUtc0 = '',
    this.turnOverUtc0 = '',
    this.volumeUtc0 = '',
    this.changePercentUtc9 = '',
    this.isUpdatedRecently = true,
    this.priceStatusEnum = PriceStatusEnum.stay,
    String? dataAt,
  }) {
    var now = DateTime.now().toUtc().add(const Duration(hours: 9));
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    _updatedAt = formatter.format(now);
    this.dataAt = dataAt ??
        _updatedAt; // dataAt 에 별도 값을 넣어주지 않으면 자동으로 updatedAt과 같은 값으로 저장
  }
}

class TickerModelAdapter extends TypeAdapter<TickerModel> {
  @override
  final int typeId = 4; // 타입 식별자입니다.

  @override
  TickerModel read(BinaryReader reader) {
    // 바이너리 데이터를 읽어 TickerModel 객체를 생성합니다.
    return TickerModel(
      price: reader.readString(),
      lastPrice: reader.readString(),
      ask1Price: reader.readString(),
      ask1Size: reader.readString(),
      bid1Price: reader.readString(),
      bid1Size: reader.readString(),
      changePercent24h: reader.readString(),
      prevPrice24h: reader.readString(),
      highPrice24h: reader.readString(),
      lowPrice24h: reader.readString(),
      turnOver24h: reader.readString(),
      volume24h: reader.readString(),
      changePercentUtc0: reader.readString(),
      prevPriceUtc0: reader.readString(),
      highPriceUtc0: reader.readString(),
      lowPriceUtc0: reader.readString(),
      turnOverUtc0: reader.readString(),
      volumeUtc0: reader.readString(),
      changePercentUtc9: reader.readString(),
      isUpdatedRecently: reader.readString() == 'true',
      priceStatusEnum: PriceStatusEnum.values[reader.readInt()],
      dataAt: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, TickerModel obj) {
    // TickerModel 객체를 바이너리 데이터로 씁니다.
    writer.writeString(obj.price);
    writer.writeString(obj.lastPrice);
    writer.writeString(obj.ask1Price);
    writer.writeString(obj.ask1Size);
    writer.writeString(obj.bid1Price);
    writer.writeString(obj.bid1Size);
    writer.writeString(obj.changePercent24h);
    writer.writeString(obj.prevPrice24h);
    writer.writeString(obj.highPrice24h);
    writer.writeString(obj.lowPrice24h);
    writer.writeString(obj.turnOver24h);
    writer.writeString(obj.volume24h);
    writer.writeString(obj.changePercentUtc0);
    writer.writeString(obj.prevPriceUtc0);
    writer.writeString(obj.highPriceUtc0);
    writer.writeString(obj.lowPriceUtc0);
    writer.writeString(obj.turnOverUtc0);
    writer.writeString(obj.volumeUtc0);
    writer.writeString(obj.changePercentUtc9);
    writer.writeString(obj.isUpdatedRecently.toString());
    writer.writeInt(obj.priceStatusEnum.index);
    writer.writeString(obj.dataAt);
  }
}
