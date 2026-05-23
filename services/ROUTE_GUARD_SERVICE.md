# Route Guard Service

Protects routes with authentication checks. Prevents unauthorized access and redirects to login.

## How It Works

RouteGuardService checks if user is authorized to access a route. If not, redirects to login and stores the pending route.

```dart
// In some navigation code:
final request = NavigationRequest(
  routeName: AppRoutes.product,
  arguments: productData,
);

// Guard checks auth before navigating
await routeGuardService.handleNavigation(request);

// If not logged in:
// 1. Saves pending route in AuthService
// 2. Redirects to login
// 3. After login, app navigates to saved route
```

## How to Use

### Check Routes Before Navigation

```dart
class MyScreen extends StatelessWidget {
  final RouteGuardService routeGuardService;
  
  const MyScreen({required this.routeGuardService, super.key});

  void navigateToProtectedRoute() async {
    final request = NavigationRequest(
      routeName: AppRoutes.product,
      arguments: productData,
    );
    
    await routeGuardService.handleNavigation(request);
  }
}
```

### Protected Routes Configuration

Currently protects: `AppRoutes.product`

To add more protected routes:

```dart
// In route_guard_service.dart handleNavigation()
if (request.routeName == AppRoutes.product ||
    request.routeName == AppRoutes.profile) {
  if (!authService.isLoggedIn) {
    // Redirect to login
    authService.pendingRoute = request.routeName;
    authService.pendingArguments = request.arguments;
    
    await navigationService.pushNamedAndRemoveUntil(AppRoutes.login);
    return;
  }
}
```

## Flow

```
User tries to access protected route
        ↓
RouteGuardService.handleNavigation()
        ↓
Check: Is user logged in?
        ↓
    YES → Navigate to requested route
    
    NO → 
      1. Save route as pending
      2. Save arguments as pending
      3. Redirect to login
      ↓
User logs in
      ↓
Check pending route
      ↓
Navigate to saved route
      ↓
Clear pending
```

## Integration

1. **AuthService** stores pending route/arguments
2. **NavigationService** handles the actual navigation
3. **NavigationRequest** (model) holds route info

```dart
class NavigationRequest {
  final String routeName;
  final Object? arguments;
  
  NavigationRequest({
    required this.routeName,
    this.arguments,
  });
}
```

## Testing

```dart
class FakeAuthService implements AuthService {
  bool isLoggedIn = false;
  String? pendingRoute;
  Object? pendingArguments;
  
  void login() => isLoggedIn = true;
  void logout() => isLoggedIn = false;
}

class FakeNavigationService implements NavigationService {
  List<String> routesPushed = [];
  
  @override
  Future<T?>? pushNamed<T>(String routeName, {Object? arguments}) {
    routesPushed.add(routeName);
    return Future.value(null);
  }
}

void main() {
  test('redirects to login when not authenticated', () async {
    final authService = FakeAuthService();
    final navService = FakeNavigationService();
    final guardService = RouteGuardService(
      authService: authService,
      navigationService: navService,
    );
    
    await guardService.handleNavigation(
      NavigationRequest(routeName: AppRoutes.product),
    );
    
    expect(navService.routesPushed, contains(AppRoutes.login));
    expect(authService.pendingRoute, AppRoutes.product);
  });
  
  test('allows navigation when authenticated', () async {
    final authService = FakeAuthService()..login();
    final navService = FakeNavigationService();
    final guardService = RouteGuardService(
      authService: authService,
      navigationService: navService,
    );
    
    await guardService.handleNavigation(
      NavigationRequest(routeName: AppRoutes.product),
    );
    
    expect(navService.routesPushed, contains(AppRoutes.product));
  });
}
```
