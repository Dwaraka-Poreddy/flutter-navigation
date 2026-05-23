# Flutter Navigation App

A Flutter navigation app with professional Dependency Injection (DI) pattern and route protection.

## Architecture

### Dependency Injection
Services are managed via GetIt, a service locator that stores and retrieves singletons.

**Services:**
- `NavigationService` - App navigation (push, pop, replace)
- `AuthService` - User authentication state
- `RouteGuardService` - Protects routes with auth checks

**Files:**
- `lib/services/service_locator.dart` - DI setup
- `lib/services/navigation_service.dart` - Navigation (injected to screens)
- `lib/services/auth_service.dart` - Authentication state
- `lib/services/route_guard_service.dart` - Route protection
- `lib/services/deep_link_service.dart` - Deep links (uses injected services)

### How It Works

1. `main()` calls `setupServiceLocator()` to register all services
2. `MyApp` retrieves services from GetIt
3. Screens receive services via constructor (dependency injection)
4. This makes dependencies explicit and code testable

### Route Protection

Protected routes (e.g., product) require authentication:
- If user is not logged in, RouteGuardService redirects to login
- After login, app navigates to the originally requested route
- See SERVICE_LOCATOR.md → ROUTE_GUARD_SERVICE.md for details

## Setup

No special setup needed. The app initializes DI in `main()`:
```dart
void main() {
  setupServiceLocator();  // Register all services
  runApp(const MyApp());
}
```

## Documentation

Each service has documentation in `lib/services/`:

- **SERVICE_LOCATOR.md** - DI patterns, registering services
- **NAVIGATION_SERVICE.md** - Navigation methods, deep linking, testing
- **AUTH_SERVICE.md** - Authentication, login/logout, pending routes
- **ROUTE_GUARD_SERVICE.md** - Route protection, auth redirects

## Adding New Services

1. Create service: `lib/services/my_service.dart`
2. Register in `service_locator.dart`:
   ```dart
   getIt.registerSingleton<MyService>(MyService());
   ```
3. Inject in screens:
   ```dart
   class MyScreen extends StatelessWidget {
     final MyService myService;
     const MyScreen({required this.myService, super.key});
   }
   ```
4. Add documentation: `lib/services/MY_SERVICE.md`

## Testing

Services are mockable for easy testing:
```dart
class FakeMyService implements MyService { ... }

testWidgets('...', (tester) async {
  await tester.pumpWidget(
    MyScreen(myService: FakeMyService()),
  );
});
```

See each service's .md file in `lib/services/` for testing templates.

## Features

- ✅ Dependency Injection with GetIt
- ✅ Navigation service (push, pop, replace)
- ✅ Authentication management
- ✅ Route protection with guards
- ✅ Deep link handling
- ✅ Testable architecture
- ✅ Clean, explicit dependencies
