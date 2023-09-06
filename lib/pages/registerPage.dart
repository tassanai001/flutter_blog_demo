import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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

  onSubmitRegister() async {
    final baseUrl = dotenv.env['BASE_URL'];

    final Map<String, String> requestBody = {
      'name': _nameController.text,
      'surname': _surnameController.text,
      'username': _usernameController.text,
      'password': _passwordController.text,
    };

    final http.Response response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      onShowDialog(
        title: 'Register Successful',
        message: '',
        navigateTo: () => Navigator.of(context).pop(),
      );
    } else {
      onShowDialog(
        title: 'Register Failed',
        message: 'Register failed with status code ${response.statusCode}',
        navigateTo: () => Navigator.of(context).pop(),
      );
    }
  }

  void _navigateToLoginPage() {
    Navigator.of(context).pop();
  }

  InputDecoration onGetDecorator({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Theme.of(context).secondaryHeaderColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: onGetDecorator(labelText: "Name"),
                      validator: (value) {
                        if (value == "") {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _surnameController,
                      decoration: onGetDecorator(labelText: "Surname"),
                      validator: (value) {
                        if (value == "") {
                          return 'Please enter your surname';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _usernameController,
                      decoration: onGetDecorator(labelText: "Username"),
                      validator: (value) {
                        if (value == "") {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: onGetDecorator(labelText: "Password"),
                      obscureText: true,
                      validator: (value) {
                        if (value == "") {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: onGetDecorator(labelText: "Confirm Password"),
                      obscureText: true,
                      validator: (value) {
                        if (value == "") {
                          return 'Please confirm your password';
                        } else if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: const StadiumBorder(),
                            ),
                            child: const Text('Register'),
                            onPressed: () {
                              if (_formKey.currentState != null) {
                                if (_formKey.currentState!.validate()) {
                                  onSubmitRegister();
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    RichText(
                      text: TextSpan(
                        text: "Already a member? ",
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _navigateToLoginPage,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
