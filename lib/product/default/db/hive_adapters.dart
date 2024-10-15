// hive_adapters.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tickerwatch/product/sample_person/person.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_entity.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_model.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_info_model.dart';
import 'package:tickerwatch/product/tickeralarm/entities/ticker_alarm_entity.dart';

void registerHiveAdapters() {
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(TickerEntityAdapter());
  Hive.registerAdapter(TickerModelAdapter());
  Hive.registerAdapter(TickerInfoModelAdapter());
  Hive.registerAdapter(TickerAlarmEntityAdapter());
  // 추가적인 어댑터는 이곳에 등록
}
