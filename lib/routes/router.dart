import 'package:flutter/material.dart';
import 'package:flutter_navigation/routes/app_route_observer.dart';
import 'package:flutter_navigation/screens/go_router/home_page.dart';
import 'package:flutter_navigation/screens/go_router/login_page.dart';
import 'package:flutter_navigation/screens/go_router/main_shell_page.dart';
import 'package:flutter_navigation/screens/go_router/product_page.dart';
import 'package:flutter_navigation/screens/go_router/search_page.dart';
import 'package:flutter_navigation/services/go_router_auth_service.dart';
import 'package:go_router/go_router.dart';

final authService = GoRouterAuthService();
final rootObserver = AppRouteObserver();
final homeObserver = AppRouteObserver();
final searchObserver = AppRouteObserver();

final GoRouter router = GoRouter(
  initialLocation: '/home',
  refreshListenable: authService,
  observers: [rootObserver],
  redirect: (context, state) {
    final loggedIn = authService.isLoggedIn;
    final loggingIn = state.matchedLocation == '/login';

    if (!loggedIn && !loggingIn) {
      return '/login';
    }
    if (loggedIn && loggingIn) {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellPage(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          observers: [homeObserver],
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) {
                return const HomePage();
              },
              routes: [
                GoRoute(
                  path: 'product/:id',
                  builder: (context, state) {
                    final productId = state.pathParameters['id']!;
                    final source = state.uri.queryParameters['source'];
                    final coupon = state.uri.queryParameters['coupon'];
                    return ProductPage(
                      productId: productId,
                      source: source,
                      coupon: coupon,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          observers: [searchObserver],
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) {
                return const SearchPage();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
