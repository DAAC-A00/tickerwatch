import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/main_screen.dart';
import 'screens/route_error_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const MainScreen(),
      routes: const [],
    ),
  ],
  errorBuilder: (context, state) => RouteErrorScreen(
    errorMsg: state.error.toString(),
    key: state.pageKey,
  ),
);
