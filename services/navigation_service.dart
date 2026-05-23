import 'package:flutter/material.dart';

/// Navigation Service - See NAVIGATION_SERVICE.md for usage patterns.
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

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
}

