// bybit_all_spot_scheduler.dart

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/tickers/states/ticker_provider.dart';
import '../../../product/tickers/entities/ticker_entity.dart';
import '../services/bybit_all_spot_api_service.dart';

class BybitAllSpotScheduler {
  final WidgetRef ref;
  Timer? _timer;

  BybitAllSpotScheduler(this.ref);

  void start() {
    const period = Duration(milliseconds: 1300);
    _timer?.cancel();
    _timer = Timer.periodic(period, (timer) async {
      List<TickerEntity>? newDataList =
          await BybitAllSpotApiService.getDataList();
      if (newDataList != null) {
        ref.read(tickerProvider.notifier).updateAllBox(newDataList);
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }

  Future<void> fetchOnce() async {
    List<TickerEntity>? newDataList =
        await BybitAllSpotApiService.getDataList();
    if (newDataList != null) {
      ref.read(tickerProvider.notifier).updateAllBox(newDataList);
    }
  }
}
