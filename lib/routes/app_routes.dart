import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../modules/main/main_wrapper.dart';
import '../modules/home/home_view.dart';
import '../modules/detail/detail_view.dart';

import '../modules/cart/cart_view.dart';
import '../modules/user/user_view.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _sectionHomeNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'sectionHomeNav');
  static final GlobalKey<NavigatorState> _sectionCartNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'sectionCartNav');
  static final GlobalKey<NavigatorState> _sectionUserNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'sectionUserNav');

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            navigatorKey: _sectionHomeNavigatorKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeView(),
                routes: [
                  GoRoute(
                    path: 'detail/:id',
                    builder: (context, state) =>
                        DetailView(productId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          // Cart Branch
          StatefulShellBranch(
            navigatorKey: _sectionCartNavigatorKey,
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CartView(),
              ),
            ],
          ),
          // User Branch
          StatefulShellBranch(
            navigatorKey: _sectionUserNavigatorKey,
            routes: [
              GoRoute(
                path: '/user',
                builder: (context, state) => const UserView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
