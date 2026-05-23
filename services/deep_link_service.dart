import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_navigation/models/navigation_request.dart';
import 'package:flutter_navigation/routes/app_routes.dart';
import 'package:flutter_navigation/services/auth_service.dart';
import 'package:flutter_navigation/services/navigation_service.dart';
import 'package:flutter_navigation/services/route_guard_service.dart';

import '../models/product_arguments.dart';

/// Deep Link Service - Handles app links and uses injected NavigationService.
/// See NAVIGATION_SERVICE.md for integration details.
class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  final NavigationService navigationService;
  final AuthService authService;
  final RouteGuardService routeGuardService;

  StreamSubscription? _sub;

  DeepLinkService({
    required this.navigationService,
    required this.authService,
    required this.routeGuardService,
  });

  void init() async {
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }

      _sub = _appLinks.uriLinkStream.listen((Uri uri) {
        _handleUri(uri);
      });
    } catch (e) {
      print("Error initializing deep links: $e");
    }
  }

  void dispose() {
    _sub?.cancel();
  }

  void _handleUri(Uri uri) async {
    if (uri.host == 'product') {
      final productArguments = ProductArguments(
        productId: uri.pathSegments.first,
        productName: uri.pathSegments[1],
        price: double.tryParse(uri.pathSegments[2]) ?? 0.0,
        isFromNotification: uri.pathSegments[3].toLowerCase() == "true",
      );

      await routeGuardService.handleNavigation(
        NavigationRequest(
          routeName: AppRoutes.product,
          arguments: productArguments,
        ),
      );
    }
  }
}
