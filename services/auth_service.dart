class AuthService {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String? pendingRoute;
  Object? pendingArguments;

  void login() {
    _isLoggedIn = true;
    print("User Logged In");
  }

  void logout() {
    _isLoggedIn = false;
    print("User Logged Out");
  }
}
