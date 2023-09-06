import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:blog_demo/pages/blogListPage.dart';
import 'package:blog_demo/pages/registerPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final baseUrl = dotenv.env['BASE_URL'];
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> saveUserData({
    required String username,
    required String name,
    required String surname,
    required String userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('name', name);
    await prefs.setString('surname', surname);
    await prefs.setString('userId', userId);
  }

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      onShowDialog(
          title: 'Login Failed',
          message: 'Please enter both username/email and password.',
          navigateTo: () => Navigator.of(context).pop());
    } else {
      final Map<String, String> requestBody = {
        'username': username,
        'password': password,
      };

      final http.Response response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // ignore: use_build_context_synchronously
        saveUserData(
          username: data['username'],
          name: data['name'],
          surname: data['surname'],
          userId: data['_id'],
        );
        onShowDialog(
            title: 'Login Successful',
            message: 'Welcome, ${data['name']} ${data['surname']}!',
            navigateTo: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const BlogListPage();
                })));
      } else {
        // ignore: use_build_context_synchronously
        onShowDialog(
            title: 'Login Failed',
            message: 'Login failed with status code ${response.statusCode}',
            navigateTo: () => Navigator.of(context).pop());
      }
    }
  }

  void onShowDialog({
    required String title,
    required String message,
    required Function navigateTo,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                navigateTo();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToRegisterPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Theme.of(context).secondaryHeaderColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CircleAvatar(
                  radius: 80.0, // Adjust the size as needed
                  backgroundImage: NetworkImage(
                      'https://www.ficaon.com/wp-content/uploads/2021/06/ilustracao-blog.png'),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Username or Email',
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  controller: _usernameController,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: _login,
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Signup',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _navigateToRegisterPage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
