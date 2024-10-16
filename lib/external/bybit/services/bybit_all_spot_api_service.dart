// bybit_all_spot_api_service.dart

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:tickerwatch/product/tickers/entities/ticker_entity.dart';
import 'package:http/http.dart' as http;
import 'package:tickerwatch/product/tickers/entities/ticker_info_model.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_model.dart';
import 'package:tickerwatch/product/tickers/enums/price_status_enum.dart';
import 'package:tickerwatch/product/tickers/utils/ticker_utils.dart';

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
      log("[ BybitAllSpotApiService.getDataList ] SocketException: $e");
    } catch (e) {
      log("[ BybitAllSpotApiService.getDataList ] Unknown Exception: $e");
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
        String? price = TickerUtils.adjustPrice(
            data.lastPrice, data.bid1Price, data.ask1Price);
        String changePercent24h = TickerUtils.calculateChangePercent(
            price, data.lastPrice, data.price24hPcnt, data.prevPrice24h);
        PriceStatusEnum priceStatusEnum =
            TickerUtils.determinePriceStatus(changePercent24h);

        final TickerModel recentTickerModel = TickerModel(
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
            priceStatusEnum: priceStatusEnum);
        final TickerEntity ticker = TickerEntity(
            info: tickerInfoModel,
            recentData: recentTickerModel,
            beforeData: TickerModel(price: ''));
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
}
