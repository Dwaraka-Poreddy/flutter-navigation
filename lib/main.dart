import 'package:flutter/material.dart';
import 'package:flutter_navigation/routes/app_routes.dart';
import 'package:flutter_navigation/routes/router.dart';
import 'package:flutter_navigation/services/auth_service.dart';
import 'package:flutter_navigation/services/deep_link_service.dart';
import 'package:flutter_navigation/services/navigation_service.dart';
import 'package:flutter_navigation/services/route_guard_service.dart';
import 'package:flutter_navigation/services/service_locator.dart';

import 'models/product_arguments.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  authService.initializeApp();
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NavigationService _navigationService = getIt<NavigationService>();
  final AuthService _authService = getIt<AuthService>();
  final RouteGuardService _routeGuardService = getIt<RouteGuardService>();

  late final DeepLinkService _deepLinkService = DeepLinkService(
    navigationService: _navigationService,
    authService: _authService,
    routeGuardService: _routeGuardService,
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      routerConfig: router,
    );
  }
}

class SplashScreen extends StatelessWidget {
  final NavigationService navService;

  const SplashScreen({required this.navService, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SplashScreen")),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await navService.pushNamed(AppRoutes.login);
              },
              child: const Text("Go To Login"),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await navService.pushNamed(AppRoutes.mainShell);
            },
            child: const Text("Go To Main Shell Screen"),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final NavigationService navService;
  final AuthService authService;

  const LoginScreen({
    required this.navService,
    required this.authService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LoginScreen")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            authService.login();

            if (authService.pendingRoute != null) {
              final route = authService.pendingRoute!;
              final arguments = authService.pendingArguments;
              authService.pendingRoute = null;
              authService.pendingArguments = null;

              await navService.pushMultipleAndRemoveUntil(
                [AppRoutes.home, route],
                arguments: [null, arguments],
              );
              return;
            }

            await navService.pushNamedAndRemoveUntil(AppRoutes.home);
          },
          child: const Text("Login"),
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
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await navService.pushNamed(AppRoutes.profile);
              },
              child: const Text("Go To Profile"),
            ),
            ElevatedButton(
              onPressed: () async {
                await navService.pushNamed(AppRoutes.mainShell);
              },
              child: const Text("Go To Main Shell Screen"),
            ),
          ],
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await widget.navService.pushNamed(
              AppRoutes.product,
              arguments: ProductArguments(
                productId: "P1001",
                productName: "iPhone",
                price: 99999,
                isFromNotification: true,
              ),
            );
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
