import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Регистрация пользователя
  Future<(User?, String?)> registerWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return (userCredential.user, null);
    } catch (e) {
      return (null, "Ошибка регистрации: ${e.toString()}");
    }
  }

  // Авторизация
  Future<(User?, String?)> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return (userCredential.user, null);
    } catch (e) {
      return (null, "Ошибка входа: ${e.toString()}");
    }
  }

  // Выход из аккаунта
  Future<void> signOut() async {
    await _auth.signOut();
  }
}