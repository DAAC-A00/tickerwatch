// naver_market_index_service.dart

import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:tickerwatch/product/tickers/entities/ticker_entity.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_info_model.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_model.dart';
import 'package:tickerwatch/product/tickers/enums/price_status_enum.dart';

class NaverMarketIndexService {
  static String urlString =
      'https://finance.naver.com/marketindex/?tabSel=exchange#tab_section';

  /// 웹 페이지에서 환율 정보를 가져오는 함수
  static Future<List<TickerEntity>?> getDataList() async {
    final url = Uri.parse(urlString);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var document = parser.parse(response.body);

      // <ul> 태그에서 환율 정보 찾기
      final List<Element> dataList = document.querySelectorAll('.data_lst li');
      List<TickerEntity> tickerList = [];

      for (var data in dataList) {
        String currencyName = data.querySelector('h3')?.text.trim() ?? '';
        String value = data.querySelector('.value')?.text.trim() ?? '';
        String change = data.querySelector('.change')?.text.trim() ?? '';
        String trend = data.querySelector('.blind')?.text.trim() ?? '';
        String source = data.querySelector('.source')?.text.trim() ?? '';
        String time = data.querySelector('.time')?.text.trim() ?? '';
        String count = data.querySelector('.count .num')?.text.trim() ?? '';

        double? price = double.tryParse(value);
        double? changePrice = double.tryParse(change);
        double? changePercentUtc9 = price != null && changePrice != null
            ? changePrice / (price - changePrice) * 100
            : null;
        PriceStatusEnum priceStatusEnum = trend == '상승'
            ? PriceStatusEnum.up
            : trend == '하락'
                ? PriceStatusEnum.down
                : PriceStatusEnum.stay;

        TickerInfoModel tickerInfo = TickerInfoModel(
          rawSymbol: currencyName,
          source: source,
          remark: count,
          searchKeywords: 'naverfiatrates$currencyName$source$count',
        );
        TickerModel tickerModel = TickerModel(
          price: value,
          changePercentUtc9: changePercentUtc9?.toStringAsFixed(2) ?? '',
          priceStatusEnum: priceStatusEnum,
          dataAt: time.length > 16
              ? time.replaceAll('.', '-')
              : '${time.replaceAll('.', '-')}:00',
        );

        // FiatRatesModel 객체 추가 (실제 구현에 맞게 수정 필요)
        tickerList.add(TickerEntity(
            info: tickerInfo,
            recentData: tickerModel,
            beforeData: TickerModel(price: '')));
      }
      return tickerList;
    } else {
      throw Exception('웹 페이지를 불러오지 못했습니다. 상태 코드: ${response.statusCode}');
    }
  }
}
