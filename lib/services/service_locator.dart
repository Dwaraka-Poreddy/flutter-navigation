import 'package:flutter_navigation/services/auth_service.dart';
import 'package:flutter_navigation/services/route_guard_service.dart';
import 'package:get_it/get_it.dart';
import 'navigation_service.dart';

final getIt = GetIt.instance;

/// Sets up Dependency Injection. See SERVICE_LOCATOR.md for details.
void setupServiceLocator() {
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<RouteGuardService>(
    RouteGuardService(
      authService: getIt<AuthService>(),
      navigationService: getIt<NavigationService>(),
    ),
  );
}
