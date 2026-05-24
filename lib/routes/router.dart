import 'package:flutter/material.dart';
import 'package:flutter_navigation/routes/app_route_observer.dart';
import 'package:flutter_navigation/screens/go_router/error_page.dart';
import 'package:flutter_navigation/screens/go_router/home_page.dart';
import 'package:flutter_navigation/screens/go_router/login_page.dart';
import 'package:flutter_navigation/screens/go_router/main_shell_page.dart';
import 'package:flutter_navigation/screens/go_router/product_page.dart';
import 'package:flutter_navigation/screens/go_router/search_page.dart';
import 'package:flutter_navigation/screens/go_router/splash_page.dart';
import 'package:flutter_navigation/services/go_router_auth_service.dart';
import 'package:go_router/go_router.dart';

final authService = GoRouterAuthService();
final rootObserver = AppRouteObserver();
final homeObserver = AppRouteObserver();
final searchObserver = AppRouteObserver();

final rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  refreshListenable: authService,
  observers: [rootObserver],
  errorBuilder: (context, state) => ErrorPage(error: state.error),
  redirect: (context, state) {
    if (!authService.appInitialized) {
      return '/splash';
    }
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
      path: '/splash',
      builder: (context, state) {
        return const SplashPage();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/fullscreen-product/:id',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductPage(productId: productId);
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
                  pageBuilder: (context, state) {
                    final productId = state.pathParameters['id']!;
                    final source = state.uri.queryParameters['source'];
                    final coupon = state.uri.queryParameters['coupon'];
                    return MaterialPage(
                      fullscreenDialog: true,
                      child: ProductPage(
                        productId: productId,
                        source: source,
                        coupon: coupon,
                      ),
                      // transitionsBuilder: (
                      //   context,
                      //   animation,
                      //   secondaryAnimation,
                      //   child,
                      // ) {
                      //   return FadeTransition(opacity: animation, child: child);
                      // },
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
