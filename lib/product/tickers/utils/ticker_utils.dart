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
      String? changePercent, String? prevPrice, String? changePrice) {
    // changePercent : 0.35, 0.00, -0.42 형태로 return되기 때문에, 저장할때 priceStatusEnum != PriceStatusEnum.down인 경우 +를 붙여서 사용해야함 (up, stay일때 + 표기)
    String finalChangePercent;
    double? changepercentDouble = double.tryParse(changePercent ?? '');

    if (price == lastPrice) {
      finalChangePercent = changepercentDouble != null
          ? (changepercentDouble * 100).toStringAsFixed(2)
          : '';
    } else {
      double? priceDouble = double.tryParse(price ?? '');
      if (priceDouble != null) {
        if (changePrice != null) {
          double? changePriceDouble = double.tryParse(changePrice);
          if (changePriceDouble != null) {
            double prevPriceDouble = priceDouble - changePriceDouble;
            finalChangePercent =
                (changePriceDouble / prevPriceDouble * 100).toStringAsFixed(2);
          } else {
            finalChangePercent = '';
          }
        } else {
          double? prevPriceDouble = double.tryParse(prevPrice ?? '');
          if (prevPriceDouble != null) {
            double changePrice = priceDouble - prevPriceDouble;
            finalChangePercent =
                (changePrice / prevPriceDouble * 100).toStringAsFixed(2);
          } else {
            finalChangePercent = '';
          }
        }
      } else {
        finalChangePercent = '';
      }
    }

    return finalChangePercent;
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
