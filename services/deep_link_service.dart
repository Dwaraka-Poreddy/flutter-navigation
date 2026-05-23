import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_navigation/routes/app_routes.dart';
import 'package:flutter_navigation/services/auth_service.dart';
import 'package:flutter_navigation/services/navigation_service.dart';

import '../models/product_arguments.dart';

/// Deep Link Service - Handles app links and uses injected NavigationService.
/// See NAVIGATION_SERVICE.md for integration details.
class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  final NavigationService navigationService;
  final AuthService authService;

  StreamSubscription? _sub;

  DeepLinkService({required this.navigationService, required this.authService});

  void init() async {
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        print("Cold Start URI: $initialUri");
        _handleUri(initialUri);
      }

      _sub = _appLinks.uriLinkStream.listen((Uri uri) {
        print("Warm Start URI: $uri");
        _handleUri(uri);
      });
    } catch (e) {
      print("Error initializing deep links: $e");
    }
  }

  void dispose() {
    _sub?.cancel();
  }

  void _handleUri(Uri uri) {
    print("Host: ${uri.host}");
    print("Path Segments: ${uri.pathSegments}");

    if (uri.host == 'product') {
      final productArguments = ProductArguments(
        productId: uri.pathSegments.first,
        productName: uri.pathSegments[1],
        price: double.tryParse(uri.pathSegments[2]) ?? 0.0,
        isFromNotification: uri.pathSegments[3].toLowerCase() == "true",
      );

      if (navigationService.navigatorKey.currentState == null) {
        print("Navigator is not ready yet");
        return;
      }

      if (!authService.isLoggedIn) {
        print("User not logged in");

        authService.pendingRoute = AppRoutes.product;
        authService.pendingArguments = productArguments;

        navigationService.pushNamed(AppRoutes.login);
        return;
      }

      navigationService.pushNamed(
        AppRoutes.product,
        arguments: productArguments,
      );
    }
  }
}
