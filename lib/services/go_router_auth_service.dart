import 'package:flutter/material.dart';

class GoRouterAuthService extends ChangeNotifier {
  bool isLoggedIn = false;
  bool appInitialized = false;
  String? pendingRoute;

  Future<void> initializeApp() async {
    await Future.delayed(const Duration(seconds: 1));
    appInitialized = true;
    notifyListeners();
  }

  void login() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }
}
