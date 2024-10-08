// naver_market_index_service.dart

import 'dart:developer';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:tickerwatch/external/naver/models/naver_fiat_rates_model.dart';

class NaverMarketIndexService {
  static String urlString =
      'https://finance.naver.com/marketindex/?tabSel=exchange#tab_section';

  /// 웹 페이지에서 환율 정보를 가져오는 함수
  static Future<List<NaverFiatRatesModel>> getData() async {
    final url = Uri.parse(urlString);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var document = parser.parse(response.body);

      // <ul> 태그에서 환율 정보 찾기
      final List<Element> dataList = document.querySelectorAll('.data_lst li');
      List<NaverFiatRatesModel> fiatRatesList = [];

      for (var data in dataList) {
        String currency = data.querySelector('h3')?.text.trim() ?? 'Unknown';
        String value = data.querySelector('.value')?.text.trim() ?? 'N/A';
        String change = data.querySelector('.change')?.text.trim() ?? 'None';
        String trend = data.querySelector('.point_up') != null ? 'Up' : 'Down';
        String source = data.querySelector('.source')?.text.trim() ?? 'N/A';
        String time = data.querySelector('.time')?.text.trim() ?? 'N/A';
        String count = data.querySelector('.count .num')?.text.trim() ?? 'N/A';

        log('currency : $currency');
        log('value : $value');
        log('change : $change');
        log('trend : $trend');
        log('source : $source');
        log('time : $time');
        log('count : $count');
        log('#########');

        // FiatRatesModel 객체 추가 (실제 구현에 맞게 수정 필요)
        fiatRatesList.add(NaverFiatRatesModel(
          currency,
          value,
          change,
          trend,
          source,
          time,
          count,
        ));
      }
      return fiatRatesList;
    } else {
      throw Exception('웹 페이지를 불러오지 못했습니다. 상태 코드: ${response.statusCode}');
    }
  }
}
