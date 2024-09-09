// bybit_all_ticker_scheduler.dart

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/external/bybit/services/bybit_all_linear_api_service.dart';
import 'package:tickerwatch/product/tickers/states/ticker_provider.dart';
import '../../../product/tickers/entities/ticker_entity.dart';
import '../services/bybit_all_spot_api_service.dart';

class BybitAllTickerScheduler {
  final WidgetRef ref;
  Timer? _timer;

  BybitAllTickerScheduler(this.ref);

  void start() {
    const period = Duration(milliseconds: 1300);
    _timer?.cancel();
    _timer = Timer.periodic(period, (timer) async {
      List<TickerEntity>? spotDataList =
          await BybitAllSpotApiService.getDataList();
      List<TickerEntity>? linearDataList =
          await BybitAllLinearApiService.getDataList();
      if (spotDataList != null) {
        ref.read(tickerProvider.notifier).updateAllBox(spotDataList);
      }
      if (linearDataList != null) {
        ref.read(tickerProvider.notifier).updateAllBox(linearDataList);
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }

  Future<void> fetchOnce() async {
    List<TickerEntity>? spotDataList =
        await BybitAllSpotApiService.getDataList();
    List<TickerEntity>? linearDataList =
        await BybitAllLinearApiService.getDataList();
    if (spotDataList != null) {
      ref.read(tickerProvider.notifier).updateAllBox(spotDataList);
    }
    if (linearDataList != null) {
      ref.read(tickerProvider.notifier).updateAllBox(linearDataList);
    }
  }
}
