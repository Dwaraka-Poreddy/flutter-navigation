import 'package:flutter/material.dart';

import '../models/product_arguments.dart';
import '../routes/app_routes.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int currentIndex = 0;

  final homeNavigatorKey = GlobalKey<NavigatorState>();

  final searchNavigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get currentTabNavigator {
    switch (currentIndex) {
      case 0:
        return homeNavigatorKey.currentState!;

      case 1:
        return searchNavigatorKey.currentState!;

      default:
        return homeNavigatorKey.currentState!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (didPop, result) async {
        if (currentTabNavigator.canPop()) {
          currentTabNavigator.pop();

          return;
        }

        Navigator.of(context).pop();
      },

      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,

          children: [
            /// HOME TAB NAVIGATOR
            Navigator(
              key: homeNavigatorKey,

              onGenerateRoute: (settings) {
                return MaterialPageRoute(builder: (_) => const HomeTab());
              },
            ),

            /// SEARCH TAB NAVIGATOR
            Navigator(
              key: searchNavigatorKey,

              onGenerateRoute: (settings) {
                return MaterialPageRoute(builder: (_) => const SearchTab());
              },
            ),
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,

          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Tab")),

      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await Navigator.of(context, rootNavigator: true).pushNamed(
              AppRoutes.product,

              arguments: ProductArguments(
                productId: "P1001",
                productName: "iPhone",
                price: 99999,
                isFromNotification: true,
              ),
            );
          },

          child: const Text("Go To Product Screen"),
        ),
      ),
    );
  }
}

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Tab")),

      body: const Center(child: Text("Search Content")),
    );
  }
}
