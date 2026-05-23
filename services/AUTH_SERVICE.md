# Auth Service

Manages user authentication state (login, logout, pending routes).

## How to Use

### In Screens
```dart
class LoginScreen extends StatelessWidget {
  final AuthService authService;
  const LoginScreen({required this.authService, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => authService.login(),
      child: Text("Login"),
    );
  }
}
```

### Check Login Status
```dart
if (authService.isLoggedIn) {
  // User is authenticated
} else {
  // User needs to login
}
```

## Properties

### `isLoggedIn`
```dart
bool get isLoggedIn => _isLoggedIn;
```
Returns whether user is currently logged in.

### `pendingRoute`
```dart
String? pendingRoute;
Object? pendingArguments;
```
Stores route info for navigation after login (used by RouteGuardService).

## Methods

### `login()`
```dart
authService.login();
```
Sets user as logged in.

### `logout()`
```dart
authService.logout();
```
Sets user as logged out.

## Integration with RouteGuardService

RouteGuardService uses AuthService to protect routes:

```dart
// If user tries to access product route without login:
if (!authService.isLoggedIn) {
  // Store the route they wanted
  authService.pendingRoute = AppRoutes.product;
  authService.pendingArguments = args;
  
  // Navigate to login
  await navigationService.pushNamedAndRemoveUntil(AppRoutes.login);
}
```

After login, navigate to the pending route:
```dart
if (authService.pendingRoute != null) {
  final route = authService.pendingRoute!;
  final args = authService.pendingArguments;
  authService.pendingRoute = null;
  authService.pendingArguments = null;
  
  navService.pushNamed(route, arguments: args);
}
```

## Testing

```dart
class FakeAuthService implements AuthService {
  @override
  bool isLoggedIn = false;
  
  @override
  String? pendingRoute;
  
  @override
  Object? pendingArguments;
  
  @override
  void login() => isLoggedIn = true;
  
  @override
  void logout() => isLoggedIn = false;
}

testWidgets('login updates state', (tester) async {
  final authService = FakeAuthService();
  expect(authService.isLoggedIn, false);
  
  authService.login();
  expect(authService.isLoggedIn, true);
});
```
