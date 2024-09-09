// bybit_all_linear_list_model.dart

class BybitAllLinearListModel {
  String? symbol;
  String? lastPrice;
  String? indexPrice;
  String? markPrice;
  String? prevPrice24h;
  String? price24hPcnt;
  String? highPrice24h;
  String? lowPrice24h;
  String? prevPrice1h;
  String? openInterest;
  String? openInterestValue;
  String? turnover24h;
  String? volume24h;
  String? fundingRate;
  String? nextFundingTime;
  String? predictedDeliveryPrice;
  String? basisRate;
  String? deliveryFeeRate;
  String? deliveryTime;
  String? ask1Size;
  String? bid1Price;
  String? ask1Price;
  String? bid1Size;
  String? basis;

  BybitAllLinearListModel(
      {this.symbol,
      this.lastPrice,
      this.indexPrice,
      this.markPrice,
      this.prevPrice24h,
      this.price24hPcnt,
      this.highPrice24h,
      this.lowPrice24h,
      this.prevPrice1h,
      this.openInterest,
      this.openInterestValue,
      this.turnover24h,
      this.volume24h,
      this.fundingRate,
      this.nextFundingTime,
      this.predictedDeliveryPrice,
      this.basisRate,
      this.deliveryFeeRate,
      this.deliveryTime,
      this.ask1Size,
      this.bid1Price,
      this.ask1Price,
      this.bid1Size,
      this.basis});

  BybitAllLinearListModel.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    lastPrice = json['lastPrice'];
    indexPrice = json['indexPrice'];
    markPrice = json['markPrice'];
    prevPrice24h = json['prevPrice24h'];
    price24hPcnt = json['price24hPcnt'];
    highPrice24h = json['highPrice24h'];
    lowPrice24h = json['lowPrice24h'];
    prevPrice1h = json['prevPrice1h'];
    openInterest = json['openInterest'];
    openInterestValue = json['openInterestValue'];
    turnover24h = json['turnover24h'];
    volume24h = json['volume24h'];
    fundingRate = json['fundingRate'];
    nextFundingTime = json['nextFundingTime'];
    predictedDeliveryPrice = json['predictedDeliveryPrice'];
    basisRate = json['basisRate'];
    deliveryFeeRate = json['deliveryFeeRate'];
    deliveryTime = json['deliveryTime'];
    ask1Size = json['ask1Size'];
    bid1Price = json['bid1Price'];
    ask1Price = json['ask1Price'];
    bid1Size = json['bid1Size'];
    basis = json['basis'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['lastPrice'] = lastPrice;
    data['indexPrice'] = indexPrice;
    data['markPrice'] = markPrice;
    data['prevPrice24h'] = prevPrice24h;
    data['price24hPcnt'] = price24hPcnt;
    data['highPrice24h'] = highPrice24h;
    data['lowPrice24h'] = lowPrice24h;
    data['prevPrice1h'] = prevPrice1h;
    data['openInterest'] = openInterest;
    data['openInterestValue'] = openInterestValue;
    data['turnover24h'] = turnover24h;
    data['volume24h'] = volume24h;
    data['fundingRate'] = fundingRate;
    data['nextFundingTime'] = nextFundingTime;
    data['predictedDeliveryPrice'] = predictedDeliveryPrice;
    data['basisRate'] = basisRate;
    data['deliveryFeeRate'] = deliveryFeeRate;
    data['deliveryTime'] = deliveryTime;
    data['ask1Size'] = ask1Size;
    data['bid1Price'] = bid1Price;
    data['ask1Price'] = ask1Price;
    data['bid1Size'] = bid1Size;
    data['basis'] = basis;
    return data;
  }
}
