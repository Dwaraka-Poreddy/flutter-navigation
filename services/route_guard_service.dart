import 'package:flutter_navigation/models/navigation_request.dart';
import 'package:flutter_navigation/routes/app_routes.dart';
import 'package:flutter_navigation/services/auth_service.dart';
import 'package:flutter_navigation/services/navigation_service.dart';

class RouteGuardService {
  final AuthService authService;
  final NavigationService navigationService;

  RouteGuardService({
    required this.authService,
    required this.navigationService,
  });

  Future<void> handleNavigation(NavigationRequest request) async {
    if (request.routeName == AppRoutes.product) {
      if (!authService.isLoggedIn) {
        authService.pendingRoute = request.routeName;
        authService.pendingArguments = request.arguments;
        await navigationService.pushNamedAndRemoveUntil(AppRoutes.login);
        return;
      }
    }

    await navigationService.pushNamed(
      request.routeName,
      arguments: request.arguments,
    );
  }
}
