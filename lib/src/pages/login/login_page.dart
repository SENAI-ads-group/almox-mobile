import 'package:flutter/material.dart';
import 'package:almox_mobile/src/pages/login/login_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "ALMOX MOBILE",
        ),
      ),
      body: LoginScreen(),
    );
  }
}
