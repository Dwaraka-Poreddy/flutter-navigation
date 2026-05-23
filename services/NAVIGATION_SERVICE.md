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

### pushNamed
```dart
navService.pushNamed(
  AppRoutes.home,
  arguments: SomeData(),
);
// Returns Future that resolves when screen pops with result
```

### pop
```dart
navService.pop("result");
```

## Deep Linking Integration

`DeepLinkService` receives `NavigationService` via constructor and uses it to navigate when links arrive:

```dart
DeepLinkService(navigationService: navService)
```

When a deep link is opened, it calls:
```dart
navigationService.pushNamed(AppRoutes.product, arguments: data);
```

## Testing

```dart
class FakeNavigationService implements NavigationService {
  List<String> routesPushed = [];
  
  @override
  Future<T?>? pushNamed<T>(String routeName, {Object? arguments}) {
    routesPushed.add(routeName);
    return Future.value(null);
  }
  
  @override
  void pop<T>([T? result]) {}
  
  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey();
}

testWidgets('navigate to home', (tester) async {
  final fake = FakeNavigationService();
  await tester.pumpWidget(MyScreen(navService: fake));
  expect(fake.routesPushed, contains(AppRoutes.home));
});
```
