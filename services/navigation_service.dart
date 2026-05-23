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
    String? baseRoute, // Route to keep (e.g., AppRoutes.home)
  }) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      baseRoute != null
          ? (route) => route.settings.name == baseRoute
          : (route) => false, // Remove all if no baseRoute
      arguments: arguments,
    );
  }
}
