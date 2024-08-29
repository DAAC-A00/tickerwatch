// bybit_all_spot_api_service.dart

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:tickerwatch/product/tickers/entities/ticker_entity.dart';
import 'package:http/http.dart' as http;
import 'package:tickerwatch/product/tickers/entities/ticker_info_model.dart';
import 'package:tickerwatch/product/tickers/enums/price_status_enum.dart';

import '../../default/exchange_raw_category_enum.dart';
import '../models/bybit_all_spot_list_model.dart';
import '../models/bybit_all_spot_model.dart';

class BybitAllSpotApiService {
  static const ExchangeRawCategoryEnum exchangeRawCategoryEnum =
      ExchangeRawCategoryEnum.bybitSpot;
  static final String endPoint =
      exchangeRawCategoryEnum.allTickerListApiEndPoint;

  static Future<List<TickerEntity>?> getDataList() async {
    final Uri uri = Uri.parse(endPoint);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return _parseResponse(response.body);
      } else {
        return [];
      }
    } on SocketException catch (e) {
      log("[ BybitAllSpotApiService : getData ] SocketException: $e");
    } catch (e) {
      log("[ BybitAllSpotApiService : getData ] Unknown Exception: $e");
    }
    return null;
  }

  static List<TickerEntity> _parseResponse(String responseBody) {
    final List<TickerEntity> tickerList = [];
    final Map<String, dynamic> bodyData = jsonDecode(responseBody);

    for (BybitAllSpotListModel data
        in BybitAllSpotModel.fromJson(bodyData).result?.list ?? []) {
      final String? rawSymbol = data.symbol;
      if (rawSymbol != null) {
        final tickerInfoModel = _createTickerInfoModel(rawSymbol);
        String? price = _adjustPrice(data);
        String changePercent24h = _calculateChangePercent(data, price);
        PriceStatusEnum priceStatusEnum =
            _determinePriceStatus(changePercent24h);

        final TickerEntity ticker = TickerEntity(
          info: tickerInfoModel,
          price: price ?? '',
          lastPrice: data.lastPrice ?? '',
          ask1Price: data.ask1Price ?? '',
          ask1Size: data.ask1Size ?? '',
          bid1Price: data.bid1Price ?? '',
          bid1Size: data.bid1Size ?? '',
          changePercent24h: priceStatusEnum == PriceStatusEnum.up
              ? '+$changePercent24h'
              : changePercent24h,
          prevPrice24h: data.prevPrice24h ?? '',
          highPrice24h: data.highPrice24h ?? '',
          lowPrice24h: data.lowPrice24h ?? '',
          turnOver24h: data.turnover24h ?? '',
          volume24h: data.volume24h ?? '',
          priceStatusEnum: priceStatusEnum,
        );
        tickerList.add(ticker);
      }
    }
    return tickerList;
  }

  static TickerInfoModel _createTickerInfoModel(String rawSymbol) {
    final tickerInfoModel = TickerInfoModel(
      rawSymbol: rawSymbol,
      exchangeRawCategoryEnum: exchangeRawCategoryEnum,
    );
    tickerInfoModel.rawToTickerInfo();
    return tickerInfoModel;
  }

  static String? _adjustPrice(BybitAllSpotListModel data) {
    String? lastPrice = data.lastPrice;
    String? price = lastPrice;
    final String? bidPriceString = data.bid1Price;
    final String? askPriceString = data.ask1Price;

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

  static String _calculateChangePercent(
      BybitAllSpotListModel data, String? price) {
    String changePercent24h;
    double? changepercent24hDouble = double.tryParse(data.price24hPcnt ?? '');

    if (price == data.lastPrice) {
      changePercent24h = changepercent24hDouble != null
          ? (changepercent24hDouble * 100).toStringAsFixed(2)
          : '';
    } else {
      double? prevPrice24h = double.tryParse(data.prevPrice24h ?? '');
      double? priceDouble = double.tryParse(price ?? '');
      if (prevPrice24h != null && priceDouble != null) {
        double changePrice = priceDouble - prevPrice24h;
        changePercent24h =
            (changePrice / prevPrice24h * 100).toStringAsFixed(2);
      } else {
        changePercent24h = '';
      }
    }

    return changePercent24h;
  }

  static PriceStatusEnum _determinePriceStatus(String changePercent24h) {
    return changePercent24h.isNotEmpty
        ? changePercent24h.startsWith('-')
            ? PriceStatusEnum.down
            : changePercent24h == '0.00'
                ? PriceStatusEnum.stay
                : PriceStatusEnum.up
        : PriceStatusEnum.stay; // 기본 상태
  }
}
