import 'package:flutter/material.dart';
import 'package:flutter_navigation/routes/app_routes.dart';
import 'package:flutter_navigation/services/deep_link_service.dart';
import 'package:flutter_navigation/services/navigation_service.dart';
import 'package:flutter_navigation/services/service_locator.dart';

import 'models/product_arguments.dart';

/// **Setup Dependency Injection before running the app**
/// This is REQUIRED - setupServiceLocator() creates and registers
/// all dependencies (NavigationService, etc.) so they're available everywhere.
void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// **Get the NavigationService from DI container**
  /// getIt<NavigationService>() retrieves the singleton instance
  /// registered in setupServiceLocator()
  final NavigationService _navigationService = getIt<NavigationService>();

  /// Create DeepLinkService and inject NavigationService
  late final DeepLinkService _deepLinkService = DeepLinkService(
    navigationService: _navigationService,
  );

  @override
  void initState() {
    super.initState();
    _deepLinkService.init();
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// Use the navigatorKey from injected service
      navigatorKey: _navigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (settings) {
        print("Route Requested: ${settings.name}");

        switch (settings.name) {
          case AppRoutes.splash:

            /// **Inject NavigationService into SplashScreen**
            /// SplashScreen receives navService as a constructor parameter
            /// So it doesn't need to know about getIt or static classes
            return MaterialPageRoute(
              builder: (_) => SplashScreen(navService: _navigationService),
            );
          case AppRoutes.login:
            return MaterialPageRoute(
              builder: (_) => LoginScreen(navService: _navigationService),
            );

          case AppRoutes.home:
            return MaterialPageRoute(
              builder: (_) => HomeScreen(navService: _navigationService),
            );

          case AppRoutes.profile:
            return MaterialPageRoute(
              builder: (_) => ProfileScreen(navService: _navigationService),
            );

          case AppRoutes.product:
            final productArguments = settings.arguments as ProductArguments;
            return MaterialPageRoute(
              builder:
                  (_) => ProductScreen(
                    navService: _navigationService,
                    productArguments: productArguments,
                  ),
            );

          default:
            return MaterialPageRoute(
              builder:
                  (_) => const Scaffold(
                    body: Center(child: Text("Route Not Found")),
                  ),
            );
        }
      },
    );
  }
}

/// **SplashScreen now receives NavigationService via constructor**
/// This is explicit: anyone reading this code can see "this screen uses navigation"
/// Before: NavigationService.pushNamed(...) - hides the dependency
/// Now: navService.pushNamed(...) - clear dependency
class SplashScreen extends StatelessWidget {
  /// **Injected dependency** - passed in constructor
  final NavigationService navService;

  const SplashScreen({required this.navService, super.key});

  @override
  Widget build(BuildContext context) {
    print("SplashScreen BUILD");

    return Scaffold(
      appBar: AppBar(title: const Text("SplashScreen")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            print("Before Push");

            /// Use injected navService instead of static class
            final result = await navService.pushNamed(AppRoutes.login);

            print("After Pop Returned result: $result");
          },
          child: const Text("Go To Login"),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final NavigationService navService;

  const LoginScreen({required this.navService, super.key});

  @override
  Widget build(BuildContext context) {
    print("LoginScreen BUILD");

    return Scaffold(
      appBar: AppBar(title: const Text("LoginScreen")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            print("Before Push");

            final result = await navService.pushNamed(AppRoutes.home);

            print("After Pop Returned result: $result");
          },
          child: const Text("Go To Home"),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final NavigationService navService;

  const HomeScreen({required this.navService, super.key});

  @override
  Widget build(BuildContext context) {
    print("HomeScreen BUILD");

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            print("Before Push");

            final result = await navService.pushNamed(AppRoutes.profile);

            print("After Pop Returned result: $result");
          },
          child: const Text("Go To Profile"),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final NavigationService navService;

  const ProfileScreen({required this.navService, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    print("initState");
  }

  @override
  void dispose() {
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("ProfileScreen BUILD");
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            print("Before Push");

            final result = await widget.navService.pushNamed(
              AppRoutes.product,
              arguments: ProductArguments(
                productId: "P1001",
                productName: "iPhone",
                price: 99999,
                isFromNotification: true,
              ),
            );

            print("After Pop Returned result: $result");
          },
          child: const Text("Go To Product Screen for iPhone"),
        ),
      ),
    );
  }
}

class ProductScreen extends StatelessWidget {
  final NavigationService navService;
  final ProductArguments productArguments;

  const ProductScreen({
    required this.navService,
    required this.productArguments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print(
      "Product Screen BUILD with productId: ${productArguments.productName}",
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("ProductScreen for ${productArguments.productName}"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            navService.pop("Hello From ProductScreen");
          },
          child: const Text("Go Back"),
        ),
      ),
    );
  }
}
