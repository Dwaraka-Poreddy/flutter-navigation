import 'package:flutter/material.dart';
import 'package:flutter_navigation/routes/router.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Open Product'),
              onPressed: () {
                context.go(
                  '/home/product/P1001'
                  '?source=notification'
                  '&coupon=SUMMER50',
                );
              },
            ),
            ElevatedButton(
              child: const Text('Open Fullscreen Product'),
              onPressed: () {
                context.go(
                  '/fullscreen-product/P1001'
                  '?source=notification'
                  '&coupon=SUMMER50',
                );
              },
            ),
            ElevatedButton(
              child: const Text('Simulate Notification'),
              onPressed: () {
                authService.logout();
                authService.pendingRoute = "/fullscreen-product/P1001";
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
