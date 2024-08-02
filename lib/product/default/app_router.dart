// app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tickerwatch/product/person_screen.dart';

import '../person_form_screem.dart';
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
  ],
  errorBuilder: (context, state) => RouteErrorScreen(
    errorMsg: state.error.toString(),
    key: state.pageKey,
  ),
);
