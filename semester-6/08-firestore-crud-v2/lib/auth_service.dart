import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<(User?, String?)> registerWithEmail(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? userId = userCredential.user?.uid;

      if (userId != null) {
        await createCollectionsForNewUser(userId, email);
      }
      return (userCredential.user, null);
    } catch (e) {
      return (null, "Ошибка регистрации: ${e.toString()}");
    }
  }

  Future<(User?, String?)> signInWithEmail(
    String email,
    String password,
  ) async {
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

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> createCollectionsForNewUser(String userId, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await FirebaseFirestore.instance.collection('carts').doc(userId).set({
      'items': {},
    });
  }

  Future<void> incrementCart(String productId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('carts').doc(userId).update({
      'items.$productId': FieldValue.increment(1),
    });
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({'Quantity': FieldValue.increment(-1)});
  }

  Future<void> decrementCart(String productId, int quantity) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (quantity == 1) {
      await FirebaseFirestore.instance.collection('carts').doc(userId).update({
        'items.$productId': FieldValue.delete(),
      });
    } else {
      await FirebaseFirestore.instance.collection('carts').doc(userId).update({
        'items.$productId': FieldValue.increment(-1),
      });
    }

    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({'Quantity': FieldValue.increment(1)});
  }
}
