# Dependency Injection Setup

## Registered Services

1. **NavigationService** - Handles app navigation
2. **AuthService** - Manages authentication state
3. **RouteGuardService** - Protects routes with auth checks

## How It Works

Instead of services being created inside code, they are registered here and injected into screens. This makes dependencies explicit and testable.

### 4-Step Pattern

**1. REGISTER** (here in setupServiceLocator)
```dart
getIt.registerSingleton<NavigationService>(NavigationService());
getIt.registerSingleton<AuthService>(AuthService());
getIt.registerSingleton<RouteGuardService>(
  RouteGuardService(
    authService: getIt<AuthService>(),
    navigationService: getIt<NavigationService>(),
  ),
);
```

**2. RETRIEVE** (in main.dart _MyAppState)
```dart
final navService = getIt<NavigationService>();
final authService = getIt<AuthService>();
```

**3. INJECT** (in main.dart onGenerateRoute)
```dart
SplashScreen(navService: _navigationService, authService: _authService)
```

**4. USE** (in screens)
```dart
navService.pushNamed(AppRoutes.login);
authService.login();
```

## Why It Matters

| Before (Static) | After (DI) |
|---|---|
| `NavigationService.pushNamed()` | `navService.pushNamed()` |
| Hidden dependency | Explicit in constructor |
| Hard to test | Easy to mock/fake |

## Common Patterns

### Stateless Widget
```dart
class MyScreen extends StatelessWidget {
  final NavigationService navService;
  final AuthService authService;
  const MyScreen({
    required this.navService,
    required this.authService,
    super.key,
  });
}
```

### Stateful Widget
```dart
class MyScreen extends StatefulWidget {
  final NavigationService navService;
  final AuthService authService;
  const MyScreen({
    required this.navService,
    required this.authService,
    super.key,
  });
}
// Access via widget.navService and widget.authService in state
```

### Add New Service
```dart
// 1. Create service
class MyService { ... }

// 2. Register in setupServiceLocator
getIt.registerSingleton<MyService>(MyService());

// 3. Inject in screens
class MyScreen extends StatelessWidget {
  final MyService myService;
  const MyScreen({required this.myService});
}
```

### Testing
```dart
class FakeNavigationService implements NavigationService { ... }
class FakeAuthService implements AuthService { ... }

testWidgets('...', (tester) async {
  await tester.pumpWidget(MyScreen(
    navService: FakeNavigationService(),
    authService: FakeAuthService(),
  ));
});
```

## Service Dependencies

Some services depend on others:
- **RouteGuardService** depends on AuthService and NavigationService
- This is handled in setupServiceLocator - order matters!

```dart
// AuthService must be registered first
getIt.registerSingleton<AuthService>(AuthService());

// Then RouteGuardService can use it
getIt.registerSingleton<RouteGuardService>(
  RouteGuardService(
    authService: getIt<AuthService>(),
    navigationService: getIt<NavigationService>(),
  ),
);
```

