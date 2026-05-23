import 'package:flutter/material.dart';
import 'package:flutter_navigation/routes/router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authService.login();
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
