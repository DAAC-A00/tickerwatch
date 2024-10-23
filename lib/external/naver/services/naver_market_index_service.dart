// naver_market_index_service.dart

import 'dart:developer';
import 'dart:io';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:tickerwatch/external/default/exchange_raw_category_enum.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_entity.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_info_model.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_model.dart';
import 'package:tickerwatch/product/tickers/enums/price_status_enum.dart';
import 'package:tickerwatch/product/tickers/utils/ticker_utils.dart';

class NaverMarketIndexService {
  static const ExchangeRawCategoryEnum exchangeRawCategoryEnum =
      ExchangeRawCategoryEnum.naverMarketIndexWeb;
  static String endPoint = exchangeRawCategoryEnum.allTickerListApiEndPoint;

  /// 웹 페이지에서 환율 정보를 가져오는 함수
  static Future<List<TickerEntity>?> getDataList() async {
    final url = Uri.parse(endPoint);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var document = parser.parse(response.body);

        // <ul> 태그에서 환율 정보 찾기
        final List<Element> dataList =
            document.querySelectorAll('.data_lst li');
        List<TickerEntity> tickerList = [];

        for (var data in dataList) {
          String rawSymbol = data.querySelector('h3')?.text.trim() ?? '';
          String value = data
                  .querySelector('.head_info .value')
                  ?.text
                  .trim()
                  .replaceAll(',',
                      '') ?? // text에서 ,를 없애는 방법으로, double.tryParse에서 null이 안나오고 정상적으로 double parse가 되는 형태로 만들기
              '';
          String change =
              data.querySelector('.head_info .change')?.text.trim() ?? '';
          PriceStatusEnum priceStatusEnum = data
                      .querySelector('.head_info')
                      ?.text
                      .contains('º¸ÇÕ') ==
                  true
              ? PriceStatusEnum.stay
              : data.querySelector('.head_info')?.text.contains('ÇÏ¶ô') == true
                  ? PriceStatusEnum.down
                  : data.querySelector('.head_info')?.text.contains('»ó½Â') ==
                          true
                      ? PriceStatusEnum.up
                      : PriceStatusEnum.stay;
          String source =
              data.querySelector('.graph_info .source')?.text.trim() ?? '';
          String time =
              data.querySelector('.graph_info .time')?.text.trim() ?? '';
          String count =
              data.querySelector('.graph_info .num')?.text.trim() ?? '';

          source = source.contains('ÇÏ³ªÀºÇà')
              ? '하나은행'
              : source.contains('½ÅÇÑÀºÇà')
                  ? '신한은행'
                  : source.contains('COMEX') ||
                          source.contains('´º¿å»óÇ°°Å·¡¼Ò')
                      ? 'COMEX(뉴욕상품거래소)'
                      : source.contains('ÇÑ±¹¼®À¯°ø»ç') ||
                              source.contains('Opinet')
                          ? 'Opinet(한국석유공사)'
                          : source.contains('NYMEX') ||
                                  source.contains('´º¿å»ó¾÷°Å·¡¼Ò')
                              ? 'NYMEX(뉴욕상업거래소)'
                              : source.contains('ICE')
                                  ? 'ICE'
                                  : source.contains('¸ð´×½ºÅ¸')
                                      ? 'MorningStar(모닝스타)'
                                      : '';

          String changePercentUtc9 = TickerUtils.calculateChangePercent(
            value.replaceAll(',', ''),
            null,
            null,
            null,
            priceStatusEnum == PriceStatusEnum.down
                ? '-${change.replaceAll(',', '')}'
                : change.replaceAll(',', ''),
          );

          TickerInfoModel tickerInfo =
              _createTickerInfoModel(rawSymbol, source, count);
          TickerModel tickerModel = TickerModel(
            price: value,
            changePercentUtc9: priceStatusEnum == PriceStatusEnum.down
                ? changePercentUtc9
                : '+$changePercentUtc9',
            priceStatusEnum: priceStatusEnum,
            dataAt: time.length > 16
                ? time.replaceAll('.', '-')
                : time.length > 13
                    ? '${time.replaceAll('.', '-')}:59'
                    : time.length > 10
                        ? '${time.replaceAll('.', '-')}:59:59'
                        : '${time.replaceAll('.', '-')} 23:59:59',
          );

          // FiatRatesModel 객체 추가 (실제 구현에 맞게 수정 필요)
          tickerList.add(TickerEntity(
            info: tickerInfo,
            recentData: tickerModel,
            beforeData: TickerModel(price: ''),
          ));
        }
        return tickerList;
      } else {
        throw Exception('웹 페이지를 불러오지 못했습니다. 상태 코드: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      // 소켓 예외 처리
      log('[ NaverMarketIndexService.getDataList ] SocketException: $e');
      return null;
    } catch (e) {
      // 다른 예외 처리
      log('[ NaverMarketIndexService.getDataList ] Error: $e');
      return null;
    }
  }

  static TickerInfoModel _createTickerInfoModel(
      String rawSymbol, String source, String count) {
    final tickerInfoModel = TickerInfoModel(
      rawSymbol: rawSymbol,
      symbolSub: '$source&&$count',
      exchangeRawCategoryEnum: exchangeRawCategoryEnum,
    );
    tickerInfoModel.rawToTickerInfo();
    return tickerInfoModel;
  }
}
