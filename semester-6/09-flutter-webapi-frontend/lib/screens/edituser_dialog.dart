import 'package:flutter/material.dart';
import 'package:frontend/services/user_api_service.dart';
import 'package:frontend/user_session.dart';
import '../models/user_model.dart';

class EdituserDialog extends StatefulWidget {
  final int userId;

  const EdituserDialog({super.key, required this.userId});

  @override
  State<EdituserDialog> createState() => _EdituserDialogState();
}

class _EdituserDialogState extends State<EdituserDialog> {
  bool _isLogin = true;
  bool _isLoading = false;
  late int? _currentUserId;
  late User? editingUser;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentUserId = (widget.userId == 0) ? null : widget.userId;
    _loadUser();

  }

  Future<void> _loadUser() async {
    editingUser = await UserApiService.getUser(_currentUserId ?? 0);
    _usernameController.text = editingUser!.username;
    _passwordController.text = editingUser!.passwd;
    setState(() {});
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
          onPressed: () async {
            final username = _usernameController.text.trim();
            final password = _passwordController.text.trim();

            setState(() {
              _isLoading = true;
            });

            try {
              final user = await UserApiService.editUser(_currentUserId ?? 0, username, password);
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
          Text("Confirm changes"),
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel")
        ),
      ],
    );
  }
}