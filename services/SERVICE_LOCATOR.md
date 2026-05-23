# Dependency Injection Setup

## How It Works

Instead of services being created inside code, they are registered here and injected into screens. This makes dependencies explicit and testable.

### 4-Step Pattern

**1. REGISTER** (here in setupServiceLocator)
```dart
getIt.registerSingleton<NavigationService>(NavigationService());
```

**2. RETRIEVE** (in main.dart _MyAppState)
```dart
final navService = getIt<NavigationService>();
```

**3. INJECT** (in main.dart onGenerateRoute)
```dart
SplashScreen(navService: _navigationService)
```

**4. USE** (in screens)
```dart
navService.pushNamed(AppRoutes.login);
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
  const MyScreen({required this.navService, super.key});
}
```

### Stateful Widget
```dart
class MyScreen extends StatefulWidget {
  final NavigationService navService;
  const MyScreen({required this.navService, super.key});
}
// Access via widget.navService in state
```

### Add New Service
```dart
getIt.registerSingleton<MyService>(MyService());
```

### Testing
```dart
class FakeNavigationService implements NavigationService { ... }

testWidgets('...', (tester) async {
  await tester.pumpWidget(MyScreen(navService: FakeNavigationService()));
});
```
