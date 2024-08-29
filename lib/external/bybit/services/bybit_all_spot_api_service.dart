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
  static ExchangeRawCategoryEnum exchangeRawCategoryEnum =
      ExchangeRawCategoryEnum.bybitSpot;
  static String endPoint = exchangeRawCategoryEnum.allTickerListApiEndPoint;

  static Future<List<TickerEntity>?> getDataList() async {
    final Uri uri = Uri.parse(endPoint);
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        // 초기 데이터 구조 생성
        List<TickerEntity> tickerList = [];

        final Map<String, dynamic> bodyData = jsonDecode(response.body);
        for (BybitAllSpotListModel data
            in BybitAllSpotModel.fromJson(bodyData).result?.list ?? []) {
          final String? rawSymbol = data.symbol;

          if (rawSymbol != null) {
            final TickerInfoModel tickerInfoModel = TickerInfoModel(
                rawSymbol: rawSymbol,
                exchangeRawCategoryEnum: exchangeRawCategoryEnum);
            tickerInfoModel.rawToTickerInfo();

            // -- 현재가 정보를 bid 가격 활용하여 조정 작업 진행
            String? lastPrice = data.lastPrice;
            String? price = lastPrice;
            final String? bidPriceString = data.bid1Price;
            final String? askPriceString = data.ask1Price;
            if (price != bidPriceString && price != askPriceString) {
              // -- price가 bid와 ask에서 멀어질 경우, price 정보를 조정
              final double? bidPrice = double.tryParse(bidPriceString ?? '');
              final double? askPrice = double.tryParse(askPriceString ?? '');
              if (bidPrice != null && askPrice != null) {
                // -- 소수점 자리수 조정
                final int bidFixedSize =
                    bidPriceString?.split('.').lastOrNull?.length ?? 0;
                final int askFixedSize =
                    askPriceString?.split('.').lastOrNull?.length ?? 0;
                // -- -- 더 큰 size로 소수점 노출 자리수 결정
                price = ((bidPrice + askPrice) / 2).toStringAsFixed(
                    bidFixedSize > askFixedSize ? bidFixedSize : askFixedSize);
              }
            }

            // -- 24hr 변동률
            String changePercent24h;
            PriceStatusEnum? priceStatusEnum;
            if (price == lastPrice) {
              // -- 가격 미조정된 경우
              double? changepercent24hDouble =
                  double.tryParse(data.price24hPcnt ?? '');
              changePercent24h = changepercent24hDouble != null
                  ? (changepercent24hDouble * 100).toStringAsFixed(2)
                  : '';
            } else {
              // -- 가격 조정된 경우
              double? prevPrice24h = double.tryParse(data.prevPrice24h ?? '');
              double? priceDouble = double.tryParse(price ?? '');
              if (prevPrice24h != null && priceDouble != null) {
                // -- 조정된 price 데이터로 changePercent24h 재계산
                double changePrice = priceDouble - prevPrice24h;
                changePercent24h =
                    (changePrice / prevPrice24h * 100).toStringAsFixed(2);
              } else {
                changePercent24h = '';
              }
            }

            // priceStatusEnum
            priceStatusEnum = changePercent24h.substring(0, 1) == '-'
                ? PriceStatusEnum.down
                : changePercent24h == '0.00'
                    ? PriceStatusEnum.stay
                    : PriceStatusEnum.up;

            final TickerEntity ticker = TickerEntity(
              info: tickerInfoModel,
              price: price ?? '',
              lastPrice: lastPrice ?? '',
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
}
