import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_navigation/routes/app_routes.dart';
import 'package:flutter_navigation/services/navigation_service.dart';

import '../models/product_arguments.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();

  StreamSubscription? _sub;

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
      final productId = uri.pathSegments.first;
      final productName = uri.pathSegments[1];
      final price = uri.pathSegments[2];
      final isFromNotification = uri.pathSegments[3];

      if (NavigationService.navigatorKey.currentState == null) {
        print("Navigator is not ready yet");
        return;
      }

      NavigationService.pushNamed(
        AppRoutes.product,
        arguments: ProductArguments(
          productId: productId,
          productName: productName,
          price: double.tryParse(price) ?? 0.0,
          isFromNotification: isFromNotification.toLowerCase() == "true",
        ),
      );
    }
  }
}
