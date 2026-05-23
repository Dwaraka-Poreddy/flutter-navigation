# Navigation Service

Handles app navigation. Injected into screens (not static) for explicit dependencies and testability.

## How to Use

### In Screens
```dart
class MyScreen extends StatelessWidget {
  final NavigationService navService;
  const MyScreen({required this.navService, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => navService.pushNamed(AppRoutes.home, arguments: data),
      child: Text("Navigate"),
    );
  }
}
```

### In main.dart onGenerateRoute
```dart
case AppRoutes.myScreen:
  return MaterialPageRoute(
    builder: (_) => MyScreen(navService: _navigationService),
  );
```

## Methods

### `pushNamed<T>`
```dart
navService.pushNamed(
  AppRoutes.home,
  arguments: SomeData(),
);
// Returns Future that resolves when screen pops with result
```

### `pop<T>`
```dart
navService.pop("result");
```

### `pushNamedAndRemoveUntil<T>`
Remove routes until baseRoute, then push a new route.

```dart
// Remove all routes, push new one
await navService.pushNamedAndRemoveUntil(AppRoutes.home);

// Remove all, keep home route
await navService.pushNamedAndRemoveUntil(
  AppRoutes.settings,
  baseRoute: AppRoutes.home,
);

// Remove everything (baseRoute: null)
await navService.pushNamedAndRemoveUntil(
  AppRoutes.login,
  baseRoute: null,
);
```

### `pushMultipleAndRemoveUntil<T>`
Push multiple routes atomically. Removes routes until baseRoute, then pushes all new routes.

Useful for post-login navigation: clear stack, then push home → product.

```dart
// Remove all, push home then product
await navService.pushMultipleAndRemoveUntil(
  [AppRoutes.home, AppRoutes.product],
  arguments: [null, productArgs],
);

// Remove until home, push settings then profile
await navService.pushMultipleAndRemoveUntil(
  [AppRoutes.settings, AppRoutes.profile],
  arguments: [null, profileArgs],
  baseRoute: AppRoutes.home,
);
```

**Parameters:**
- `routeNames` - List of routes to push in order
- `arguments` - Optional list of arguments for each route
- `baseRoute` - Optional route to keep (removes all if null)

## Deep Linking Integration

`DeepLinkService` receives `NavigationService` via constructor and uses it to navigate when links arrive:

```dart
DeepLinkService(navigationService: navService)
```

When a deep link is opened, it calls:
```dart
navigationService.pushNamed(AppRoutes.product, arguments: data);
```

## Route Guard Integration

`RouteGuardService` uses NavigationService to enforce auth-protected routes:

```dart
// RouteGuardService uses navigationService internally
await routeGuardService.handleNavigation(navigationRequest);
```

If user is not authenticated, RouteGuardService:
1. Saves the requested route as pending
2. Uses navigationService to redirect to login
3. After login, navigates to the saved route

See ROUTE_GUARD_SERVICE.md for details.

## Testing

```dart
class FakeNavigationService implements NavigationService {
  List<String> routesPushed = [];
  List<String> routesPopped = [];
  
  @override
  Future<T?>? pushNamed<T>(String routeName, {Object? arguments}) {
    routesPushed.add(routeName);
    return Future.value(null);
  }
  
  @override
  void pop<T>([T? result]) {
    routesPopped.add('pop');
  }
  
  @override
  Future<T?>? pushNamedAndRemoveUntil<T extends Object?>(
    String routeName, {
    Object? arguments,
    required bool Function(RouteSettings) predicate,
  }) {
    routesPushed.add(routeName);
    return Future.value(null);
  }
  
  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey();
}

testWidgets('navigate to home', (tester) async {
  final fake = FakeNavigationService();
  await tester.pumpWidget(MyScreen(navService: fake));
  
  await tester.tap(find.byType(ElevatedButton));
  
  expect(fake.routesPushed, contains(AppRoutes.home));
});

testWidgets('remove until and navigate', (tester) async {
  final fake = FakeNavigationService();
  
  fake.pushNamedAndRemoveUntil(
    AppRoutes.home,
    predicate: (route) => route.settings.name == AppRoutes.login,
  );
  
  expect(fake.routesPushed, contains(AppRoutes.home));
});
```

