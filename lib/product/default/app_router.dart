// app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tickerwatch/product/person_screen.dart';

import 'screens/main_screen.dart';
import 'screens/route_error_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const MainScreen(),
      routes: [
        GoRoute(
          path: 'person',
          builder: (BuildContext context, GoRouterState state) =>
              const PersonScreen(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => RouteErrorScreen(
    errorMsg: state.error.toString(),
    key: state.pageKey,
  ),
);
