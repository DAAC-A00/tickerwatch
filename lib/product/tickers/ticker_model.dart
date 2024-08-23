// ticker_model.dart

import 'package:intl/intl.dart';

import 'ticker_info_model.dart';

class TickerModel {
  // MarketPairDetailModel
  // -- raw
  final TickerInfoModel? info;

  // 지속적으로 변하는 데이터
  // -- 현재 호가
  String? price;
  String? ask1Price;
  String? ask1Size;
  String? bid1Price;
  String? bid1Size;

  // -- 24h
  String? changePercent24h;
  String? prevPrice24h;
  String? highPrice24h;
  String? lowPrice24h;
  String? turnOver24h; // 거래대금 = quoteCode 기준 거래량
  String? volume24h; // 거래량 = baseCode 기준 거래량

  // -- UTC0
  String? changePercentUtc0;
  String? prevPriceUtc0;
  String? highPriceUtc0;
  String? lowPriceUtc0;
  String? turnOverUtc0; // 거래대금 = quoteCode 기준 거래량
  String? volumeUtc0; // 거래량 = baseCode 기준 거래량

  // -- dataAt : 해당 데이터가 타기관에서 기록된 시점
  // -- updatedAt : 해당 데이터가 본 프로그램 내에서 수정된 시점
  String? dataAt;
  String? _updatedAt;

  bool? isColorLong;

  String get updatedAt => _updatedAt!;

  TickerModel({
    required this.info,
    this.price,
    this.ask1Price,
    this.ask1Size,
    this.bid1Price,
    this.bid1Size,
    this.changePercent24h,
    this.prevPrice24h,
    this.highPrice24h,
    this.lowPrice24h,
    this.turnOver24h,
    this.volume24h,
    this.changePercentUtc0,
    this.prevPriceUtc0,
    this.highPriceUtc0,
    this.lowPriceUtc0,
    this.turnOverUtc0,
    this.volumeUtc0,
    this.isColorLong,
    String? dataAt,
  }) {
    var now = DateTime.now().toUtc().add(const Duration(hours: 9));
    var formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    String formattedDate = formatter.format(now);
    _updatedAt = formattedDate;

    this.dataAt = dataAt ??
        formattedDate; // dataAt 에 별도 값을 넣어주지 않으면 자동으로 updatedAt과 같은 값으로 저장
  }
}
