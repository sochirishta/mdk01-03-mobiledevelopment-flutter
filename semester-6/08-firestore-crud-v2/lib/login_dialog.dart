import 'package:firestore_crud_v2/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _auth = UserLogic();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  String? errorText;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isLogin ? "Sign In" : "Sign Up"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          if (errorText != null) ...[
            const SizedBox(height: 12),
            Text(errorText!, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final email = _emailController.text.trim();
            final password = _passwordController.text.trim();

            final (User? user, String? error) = _isLogin
                ? await _auth.signInWithEmail(email, password)
                : await _auth.registerWithEmail(email, password);

            if (error != null) {
              setState(() {
                errorText = error;
              });
              return;
            }
            if (user != null) {
              Navigator.pop(context);
            }
          },
          child: Text(_isLogin ? 'Sign In' : 'Sign Up'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isLogin = !_isLogin;
              errorText = null;
            });
          },
          child: Text(
            _isLogin
                ? 'Don\'t have account? Sign Up'
                : 'Already have an account? Sign In',
          ),
        ),
      ],
    );
  }
}