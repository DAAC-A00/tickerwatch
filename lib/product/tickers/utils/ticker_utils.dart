// ticker_utils.dart

import 'package:tickerwatch/product/tickers/enums/price_status_enum.dart';

class TickerUtils {
  static String? adjustPrice(
      String? lastPrice, String? bidPriceString, String? askPriceString) {
    String? price = lastPrice;

    if (price != bidPriceString && price != askPriceString) {
      final double? bidPrice = double.tryParse(bidPriceString ?? '');
      final double? askPrice = double.tryParse(askPriceString ?? '');
      if (bidPrice != null && askPrice != null) {
        final int bidFixedSize = bidPriceString?.split('.').last.length ?? 0;
        final int askFixedSize = askPriceString?.split('.').last.length ?? 0;
        price = ((bidPrice + askPrice) / 2).toStringAsFixed(
            bidFixedSize > askFixedSize ? bidFixedSize : askFixedSize);
      }
    }
    return price;
  }

  static String calculateChangePercent(String? price, String? lastPrice,
      String? price24hPcnt, String? prevPrice24h) {
    String changePercent24h;
    double? changepercent24hDouble = double.tryParse(price24hPcnt ?? '');

    if (price == lastPrice) {
      changePercent24h = changepercent24hDouble != null
          ? (changepercent24hDouble * 100).toStringAsFixed(2)
          : '';
    } else {
      double? prevPrice = double.tryParse(prevPrice24h ?? '');
      double? priceDouble = double.tryParse(price ?? '');
      if (prevPrice != null && priceDouble != null) {
        double changePrice = priceDouble - prevPrice;
        changePercent24h = (changePrice / prevPrice * 100).toStringAsFixed(2);
      } else {
        changePercent24h = '';
      }
    }

    return changePercent24h;
  }

  static PriceStatusEnum determinePriceStatus(String changePercent24h) {
    return changePercent24h.isNotEmpty
        ? changePercent24h.startsWith('-')
            ? PriceStatusEnum.down
            : changePercent24h == '0.00'
                ? PriceStatusEnum.stay
                : PriceStatusEnum.up
        : PriceStatusEnum.stay; // 기본 상태
  }
}
