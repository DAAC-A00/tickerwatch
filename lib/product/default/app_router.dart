// app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tickerwatch/product/admin/screens/admin_main_screen.dart';
import 'package:tickerwatch/product/allticker/screens/all_ticker_main_screen.dart';
import 'package:tickerwatch/product/default/screens/splash_screen.dart';
import 'package:tickerwatch/product/home/screens/home_main_screen.dart';
import 'package:tickerwatch/product/sample_person/person_main_screen.dart';
import 'package:tickerwatch/product/setting/screens/exchange_setting_screen.dart';
import 'package:tickerwatch/product/setting/screens/setting_main_screen.dart';
import 'package:tickerwatch/product/tickeralarm/screens/ticker_alarm_main_screen.dart';
import '../counter/counter_main_screen.dart';
import '../sample_person/person_form_screen.dart';
import '../setting/screens/ticker_setting_screen.dart';
import 'screens/default_screen.dart';
import 'screens/route_error_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: _buildRoutes(),
  errorBuilder: (context, state) => RouteErrorScreen(
    errorMsg: state.error.toString(),
    key: state.pageKey,
  ),
);

// 라우트 설정을 별도의 함수로 분리
List<RouteBase> _buildRoutes() {
  return [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const SplashScreen(),
      routes: [
        GoRoute(
          path: 'default',
          builder: (BuildContext context, GoRouterState state) =>
              const DefaultScreen(),
        ),
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) =>
              const HomeMainScreen(),
        ),
        GoRoute(
          path: 'tickerAlarm',
          builder: (BuildContext context, GoRouterState state) =>
              const TickerAlarmMainScreen(),
        ),
        GoRoute(
          path: 'setting',
          builder: (BuildContext context, GoRouterState state) =>
              const SettingMainScreen(),
          routes: [
            GoRoute(
              path: 'ticker',
              builder: (BuildContext context, GoRouterState state) =>
                  const TickerSettingScreen(),
            ),
            GoRoute(
              path: 'exchange',
              builder: (BuildContext context, GoRouterState state) =>
                  const ExchangeSettingScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'admin',
          builder: (BuildContext context, GoRouterState state) =>
              const AdminMainScreen(),
        ),
        GoRoute(
          path: 'allticker',
          builder: (BuildContext context, GoRouterState state) =>
              const AllTickerMainScreen(),
        ),
        GoRoute(
          path: 'counter',
          builder: (BuildContext context, GoRouterState state) =>
              const CounterMainScreen(),
        ),
        GoRoute(
          path: 'person',
          builder: (BuildContext context, GoRouterState state) =>
              const PersonMainScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (BuildContext context, GoRouterState state) =>
                  const PersonFormScreen(),
            ),
            GoRoute(
              path: 'edit/:index',
              builder: (BuildContext context, GoRouterState state) {
                final index = int.tryParse(state.pathParameters['index'] ?? '');
                final extra = state.extra as Map<String, dynamic>?;
                if (index != null &&
                    extra != null &&
                    extra.containsKey('person')) {
                  final person = extra['person'];
                  return PersonFormScreen(index: index, person: person);
                } else {
                  return const Scaffold(
                    body: Center(child: Text('Invalid index or person data')),
                  );
                }
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
