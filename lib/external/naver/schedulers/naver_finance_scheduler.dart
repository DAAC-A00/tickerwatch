// naver_finance_scheduler.dart

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/external/naver/services/naver_market_index_service.dart';
import 'package:tickerwatch/product/tickers/states/ticker_provider.dart';
import '../../../product/tickers/entities/ticker_entity.dart';

class NaverFinanceScheduler {
  final WidgetRef ref;
  Timer? _timer;

  NaverFinanceScheduler(this.ref);

  void start() {
    // 스케줄러 가동시 period duration 시작 전에 일단 1번 최신화하기
    fetchOnce();
    // 스케줄러 가동
    const period = Duration(milliseconds: 15000);
    _timer?.cancel();
    _timer = Timer.periodic(period, (timer) async {
      List<TickerEntity>? tickerDataList =
          await NaverMarketIndexService.getDataList();
      if (tickerDataList != null) {
        ref.read(tickerProvider.notifier).updateAllBox(tickerDataList);
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }

  Future<void> fetchOnce() async {
    List<TickerEntity>? tickerDataList =
        await NaverMarketIndexService.getDataList();
    if (tickerDataList != null) {
      ref.read(tickerProvider.notifier).updateAllBox(tickerDataList);
    }
  }
}
