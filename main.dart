import 'package:flutter/material.dart';
import 'package:flutter_navigation/routes/app_routes.dart';
import 'package:flutter_navigation/services/deep_link_service.dart';
import 'package:flutter_navigation/services/navigation_service.dart';

import 'models/product_arguments.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DeepLinkService _deepLinkService = DeepLinkService();
  final GlobalKey<NavigatorState> _navigatorKey =
      NavigationService.navigatorKey;

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
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (settings) {
        print("Route Requested: ${settings.name}");

        switch (settings.name) {
          case AppRoutes.splash:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case AppRoutes.login:
            return MaterialPageRoute(builder: (_) => const LoginScreen());

          case AppRoutes.home:
            return MaterialPageRoute(builder: (_) => const HomeScreen());

          case AppRoutes.profile:
            return MaterialPageRoute(builder: (_) => const ProfileScreen());

          case AppRoutes.product:
            final productArguments = settings.arguments as ProductArguments;
            return MaterialPageRoute(
              builder: (_) => ProductScreen(productArguments: productArguments),
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

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("SplashScreen BUILD");

    return Scaffold(
      appBar: AppBar(title: const Text("SplashScreen")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            print("Before Push");

            final result = await NavigationService.pushNamed(AppRoutes.login);

            print("After Pop Returned result: $result");
          },
          child: const Text("Go To Login"),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("LoginScreen BUILD");

    return Scaffold(
      appBar: AppBar(title: const Text("LoginScreen")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            print("Before Push");

            final result = await NavigationService.pushNamed(AppRoutes.home);

            print("After Pop Returned result: $result");
          },
          child: const Text("Go To Home"),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("HomeScreen BUILD");

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            print("Before Push");

            final result = await NavigationService.pushNamed(AppRoutes.profile);

            print("After Pop Returned result: $result");
          },
          child: const Text("Go To Profile"),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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

            final result = await NavigationService.pushNamed(
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
  final ProductArguments productArguments;
  const ProductScreen({required this.productArguments, super.key});

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
            NavigationService.pop("Hello From ProductScreen");
          },
          child: const Text("Go Back"),
        ),
      ),
    );
  }
}
