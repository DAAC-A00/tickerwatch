// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tickerwatch/external/naver/schedulers/naver_finance_scheduler.dart';
import 'package:tickerwatch/product/default/db/hive_adapters.dart';
import 'package:tickerwatch/product/setting/states/common_setting_provider.dart';

import 'external/bybit/schedulers/bybit_all_ticker_api_service.dart';
import 'product/default/app_router.dart';
import 'product/default/custom_theme.dart';
import 'product/tickers/states/ticker_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();

  registerHiveAdapters();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final BybitAllTickerScheduler bybitTickerScheduler;
  late final NaverFinanceScheduler naverFinanceScheduler;

  @override
  void initState() {
    super.initState();
    bybitTickerScheduler = BybitAllTickerScheduler(ref);
    naverFinanceScheduler = NaverFinanceScheduler(ref);
    _fetchInitialData(); // 비동기 초기 데이터 가져오기
  }

  Future<void> _fetchInitialData() async {
    // commonSettingProvider 값을 정상적으로 불러오도록 기다리기 위해 1초 대기
    await Future.delayed(const Duration(seconds: 1));

    // commonSettingProvider의 isSuperMode에 따라 동작 결정
    final commonSettingState = ref.read(commonSettingProvider);
    if (commonSettingState.isSuperMode) {
      bybitTickerScheduler.start();
      naverFinanceScheduler.start();
    } else {
      bybitTickerScheduler.stop();
      bybitTickerScheduler.fetchOnce();
      naverFinanceScheduler.stop();
      naverFinanceScheduler.fetchOnce();
    }
  }

  @override
  void dispose() {
    bybitTickerScheduler.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 앱 실행시 데이터 저장이 정상적으로 되도록 선언
    ref.watch(tickerProvider);

    // 공통 설정값 가져오기
    final commonSettingState = ref.watch(commonSettingProvider);

    // baseSize
    final double baseSize = MediaQuery.of(context).size.shortestSide;
    final customTheme = CustomTheme(baseSize: baseSize);

    return MaterialApp.router(
      routeInformationParser: appRouter
          .routeInformationParser, // URI String을 상태 및 GoRouter에서 사용할 수 있는 형태로 변환해주는 함수
      routeInformationProvider:
          appRouter.routeInformationProvider, // 라우트 상태를 전달해주는 함수
      routerDelegate: appRouter
          .routerDelegate, // routeInformationParser에서 변환된 값을 어떤 라우트로 보여줄 지 정하는 함수
      theme: customTheme.lightThemeData,
      darkTheme: customTheme.darkThemeData,
      themeMode:
          commonSettingState.isLightMode ? ThemeMode.light : ThemeMode.dark,
    );
  }
}
