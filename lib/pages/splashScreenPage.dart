import 'package:flutter/material.dart';

import '../services/authHelper.service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthHelper.isAuthenticated().then((bool isAuthenticated) {
      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/blogList');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF875BF7)),
      ),
    );
  }
}
