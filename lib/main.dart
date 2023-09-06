import 'package:blog_demo/pages/blogListPage.dart';
import 'package:blog_demo/pages/loginPage.dart';
import 'package:blog_demo/pages/splashScreenPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF875BF7),
        secondaryHeaderColor: const Color(0xFFEEF4FF),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/blogList': (context) => const BlogListPage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
