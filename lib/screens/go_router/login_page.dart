import 'package:flutter/material.dart';
import 'package:flutter_navigation/routes/router.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                authService.login();

                final pendingRoute = authService.pendingRoute;
                if (pendingRoute != null) {
                  authService.pendingRoute = null;
                  context.go(pendingRoute);
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
