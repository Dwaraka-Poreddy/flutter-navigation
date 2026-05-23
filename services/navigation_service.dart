import 'package:flutter/material.dart';

/// Navigation Service - See NAVIGATION_SERVICE.md for usage patterns.
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T?>? pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  void pop<T extends Object?>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }

  Future<T?>? pushNamedAndRemoveUntil<T extends Object?>(
    String routeName, {
    Object? arguments,
    String? baseRoute,
  }) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      baseRoute != null
          ? (route) => route.settings.name == baseRoute
          : (route) => false,
      arguments: arguments,
    );
  }

  Future<void> pushMultipleAndRemoveUntil<T extends Object?>(
    List<String> routeNames, {
    List<Object?>? arguments,
    String? baseRoute,
  }) async {
    pushNamedAndRemoveUntil(
      routeNames.first,
      arguments:
          arguments != null && arguments.isNotEmpty ? arguments[0] : null,
      baseRoute: baseRoute,
    );

    for (int i = 1; i < routeNames.length; i++) {
      pushNamed(
        routeNames[i],
        arguments:
            arguments != null && i < arguments.length ? arguments[i] : null,
      );
    }
  }
}
