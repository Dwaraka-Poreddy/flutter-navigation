class AuthService {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String? pendingRoute;
  Object? pendingArguments;

  void login() {
    _isLoggedIn = true;
  }

  void logout() {
    _isLoggedIn = false;
  }
}
