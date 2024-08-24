// bybit_all_spot_list_model.dart

class BybitAllSpotListModel {
  String? symbol;
  String? bid1Price;
  String? bid1Size;
  String? ask1Price;
  String? ask1Size;
  String? lastPrice;
  String? prevPrice24h;
  String? price24hPcnt;
  String? highPrice24h;
  String? lowPrice24h;
  String? turnover24h;
  String? volume24h;
  String? usdIndexPrice;

  BybitAllSpotListModel(
      {this.symbol,
      this.bid1Price,
      this.bid1Size,
      this.ask1Price,
      this.ask1Size,
      this.lastPrice,
      this.prevPrice24h,
      this.price24hPcnt,
      this.highPrice24h,
      this.lowPrice24h,
      this.turnover24h,
      this.volume24h,
      this.usdIndexPrice});

  BybitAllSpotListModel.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    bid1Price = json['bid1Price'];
    bid1Size = json['bid1Size'];
    ask1Price = json['ask1Price'];
    ask1Size = json['ask1Size'];
    lastPrice = json['lastPrice'];
    prevPrice24h = json['prevPrice24h'];
    price24hPcnt = json['price24hPcnt'];
    highPrice24h = json['highPrice24h'];
    lowPrice24h = json['lowPrice24h'];
    turnover24h = json['turnover24h'];
    volume24h = json['volume24h'];
    usdIndexPrice = json['usdIndexPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['bid1Price'] = bid1Price;
    data['bid1Size'] = bid1Size;
    data['ask1Price'] = ask1Price;
    data['ask1Size'] = ask1Size;
    data['lastPrice'] = lastPrice;
    data['prevPrice24h'] = prevPrice24h;
    data['price24hPcnt'] = price24hPcnt;
    data['highPrice24h'] = highPrice24h;
    data['lowPrice24h'] = lowPrice24h;
    data['turnover24h'] = turnover24h;
    data['volume24h'] = volume24h;
    data['usdIndexPrice'] = usdIndexPrice;
    return data;
  }
}
