import 'package:flutter/material.dart';

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route route, Route? previousRoute) {
    print('PUSH: ${route.settings.name}');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print('POP: ${route.settings.name}');
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    print(
      'REPLACE: '
      '${oldRoute?.settings.name}'
      ' → '
      '${newRoute?.settings.name}',
    );

    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
