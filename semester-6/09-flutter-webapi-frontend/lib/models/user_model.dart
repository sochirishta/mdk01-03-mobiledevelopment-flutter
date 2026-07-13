import 'package:frontend/models/cartItem_model.dart';

class User {
  final int idUser;
  final String username;
  final String passwd;
  final List<CartItem> cartItems;

  User({
    required this.idUser,
    required this.username,
    required this.passwd,
    required this.cartItems,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['idUser'] as int,
      username: (json['userName']).toString(),
      passwd: (json['userPwd']).toString(),
      cartItems: (json['cartitems'] as List<dynamic>? ?? [])
        .map((item) => CartItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'userName': username,
      'userPwd': passwd,
      'cartitems': cartItems.map((item) => item.toJson()).toList(),
    };
  }
}