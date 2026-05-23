import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open Product'),
          onPressed: () {
            context.go(
              '/home/product/P1001'
              '?source=notification'
              '&coupon=SUMMER50',
            );
          },
        ),
      ),
    );
  }
}
