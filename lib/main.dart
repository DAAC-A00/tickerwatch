// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tickerwatch/product/setting/states/common_setting_provider.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_entity.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_info_model.dart';

import 'external/bybit/schedulers/bybit_all_spot_api_service.dart';
import 'product/default/app_router.dart';
import 'product/default/custom_theme.dart';
import 'product/sample_person/person.dart';
import 'product/tickers/states/ticker_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register the PersonAdapter
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(TickerEntityAdapter());
  Hive.registerAdapter(TickerInfoModelAdapter());

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final BybitAllSpotScheduler bybitSpotScheduler;

  @override
  void initState() {
    super.initState();
    bybitSpotScheduler = BybitAllSpotScheduler(ref);
    bybitSpotScheduler.start();
  }

  @override
  void dispose() {
    bybitSpotScheduler.stop();
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
