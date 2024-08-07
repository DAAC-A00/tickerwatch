// app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tickerwatch/product/sample_person/person_main_screen.dart';
import 'package:tickerwatch/product/setting/screens/setting_main_screen.dart';
import '../home/home_main_screen.dart';
import '../sample_person/person_form_screen.dart';
import 'screens/default_screen.dart';
import 'screens/route_error_screen.dart';

// GoRouter 인스턴스를 생성하고 초기 위치를 '/'로 설정
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
          const DefaultScreen(),
      routes: [
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) =>
              const HomeMainScreen(),
        ),
        GoRoute(
          path: 'setting',
          builder: (BuildContext context, GoRouterState state) =>
              const SettingMainScreen(),
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
