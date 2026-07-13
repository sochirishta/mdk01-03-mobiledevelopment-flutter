class Product {
  final int id_product;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  Product({
    required this.id_product,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id_product: json['idProduct'] as int,
        name: (json['nameProduct'] ?? 'Без названия').toString(),
        imageUrl: (json['imageurl'] ?? '').toString(),
        price: (json['price'] as num?)?.toDouble() ?? 0,
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProduct': id_product,
      'nameProduct': name,
      'price': price,
      'quantity': quantity,
      'imageurl': imageUrl,
    };
  }
}