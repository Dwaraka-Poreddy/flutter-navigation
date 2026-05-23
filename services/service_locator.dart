import 'package:get_it/get_it.dart';
import 'navigation_service.dart';

final getIt = GetIt.instance;

/// Sets up Dependency Injection. See SERVICE_LOCATOR.md for details.
void setupServiceLocator() {
  getIt.registerSingleton<NavigationService>(NavigationService());
}
