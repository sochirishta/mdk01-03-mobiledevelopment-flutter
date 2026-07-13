import 'package:flutter/material.dart';
import 'package:frontend/user_session.dart';
import 'screens/products_screen.dart';
import 'screens/sign_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final int? savedUserId = await UserSession.getSession();
  runApp(MyApp(savedUserId: savedUserId));
}

class MyApp extends StatelessWidget {
  final int? savedUserId;

  const MyApp({super.key, this.savedUserId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Store',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: ProductsScreen(userId: savedUserId),
    );
  }
}
