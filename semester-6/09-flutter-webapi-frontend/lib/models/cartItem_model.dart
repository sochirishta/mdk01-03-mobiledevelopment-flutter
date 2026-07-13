import 'package:frontend/models/product_model.dart';

class CartItem {
  final int idCartItem;
  final Product product;
  final int userId;
  final int addedQuantity;

  CartItem({
    required this.idCartItem,
    required this.product,
    required this.userId,
    required this.addedQuantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      idCartItem: json['idCartitem'] as int,
      product: Product.fromJson(json['product']),
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      addedQuantity: (json['addedquantity'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCartitem': idCartItem,
      'product': product.toJson(),
      'userId': userId,
      'addedquantity': addedQuantity,
    };
  }
}