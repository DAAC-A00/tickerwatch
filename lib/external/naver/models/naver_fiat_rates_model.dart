// naver_fiat_rates_model.dart

class NaverFiatRatesModel {
  final String currency;
  final String value;
  final String change;
  final String trend;
  final String source;
  final String time;
  final String count;

  NaverFiatRatesModel(
    this.currency,
    this.value,
    this.change,
    this.trend,
    this.source,
    this.time,
    this.count,
  );
}
