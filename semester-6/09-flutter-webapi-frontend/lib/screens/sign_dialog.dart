import 'package:flutter/material.dart';
import 'package:frontend/services/user_api_service.dart';
import '../models/user_model.dart';

class SignDialog extends StatefulWidget {
  final int userId;

  const SignDialog({super.key, required this.userId});

  @override
  State<SignDialog> createState() => _SignDialogState();
}

class _SignDialogState extends State<SignDialog> {
  bool _isLogin = true;
  bool _isLoading = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
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
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
            enabled: !_isLoading,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            enabled: !_isLoading,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: _isLoading ? null : () async {
            final username = _usernameController.text.trim();
            final password = _passwordController.text.trim();

            setState(() {
              _isLoading = true;
            });

            try {
              final user = _isLogin
                  ? await UserApiService.signIn(username, password)
                  : await UserApiService.signUp(username, password);
                if (mounted) Navigator.pop(context, user);
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(e.toString())));
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
          },
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) :
          Text(_isLogin ? 'Sign In' : 'Sign Up'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isLogin = !_isLogin;
            });
          },
          child: Text(
            _isLogin
                ? 'Don\'t have account? Sign Up'
                : 'Already have an account? Sign In',
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Return to Store")
          ),
      ],
    );
  }
}
