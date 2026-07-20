import 'package:flutter/material.dart';

void main() => runApp(const ExampleApp());

/// Root widget for the widget_test_kit example app.
class ExampleApp extends StatelessWidget {
  /// Creates the example app.
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'widget_test_kit example',
      home: const Scaffold(body: LoginForm()),
    );
  }
}

/// A minimal login form used to demonstrate widget_test_kit's form,
/// gesture, matcher, robot, and accessibility helpers in the accompanying
/// tests under `test/login_test.dart`.
class LoginForm extends StatefulWidget {
  /// Creates the login form.
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _loading = false;
  bool _loggedIn = false;

  Future<void> _submit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _loggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loggedIn) {
      return const Center(child: Text('Welcome'));
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://example.com/avatar.png',
            width: 64,
            height: 64,
          ),
          const SizedBox(height: 16),
          TextField(
            key: const Key('email'),
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('password'),
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 16),
          if (_loading)
            const CircularProgressIndicator()
          else
            ElevatedButton(onPressed: _submit, child: const Text('Login')),
        ],
      ),
    );
  }
}
