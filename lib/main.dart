// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'product/default/app_router.dart';
import 'product/default/custom_theme.dart';
import 'product/default/person.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register the PersonAdapter
  Hive.registerAdapter(PersonAdapter());

  await Hive.openBox<int>('counterBox');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
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
      themeMode: ThemeMode.dark,
    );
  }
}
