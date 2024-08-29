// bybit_all_spot_api_service.dart

import '../../default/exchange_raw_category_enum.dart';

class BybitAllSpotApiService {
  static ExchangeRawCategoryEnum exchangeRawCategoryEnum =
      ExchangeRawCategoryEnum.bybitSpot;
  static String endPoint = exchangeRawCategoryEnum.allTickerListApiEndPoint;
}
