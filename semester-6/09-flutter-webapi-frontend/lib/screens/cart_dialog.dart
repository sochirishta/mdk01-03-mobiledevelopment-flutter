import 'package:flutter/material.dart';
import 'package:frontend/models/cartItem_model.dart';
import 'package:frontend/screens/products_screen.dart';
import 'package:frontend/services/cartitem_api_service.dart';

class CartDialog extends StatefulWidget {
  final int userId;

  const CartDialog({super.key, required this.userId});

  @override
  State<CartDialog> createState() => _CartDialogState();
}

class _CartDialogState extends State<CartDialog> {
  late Future<List<CartItem>> futureCartItems;
  late int _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = widget.userId;
    futureCartItems = CartitemApiService.getCartItems(_currentUserId);
  }

  Future<void> refreshCartItems() async {
    setState(() {
      futureCartItems = CartitemApiService.getCartItems(_currentUserId);
    });
    await futureCartItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: refreshCartItems,
        child: FutureBuilder<List<CartItem>>(
          future: futureCartItems,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ListView(
                children: [
                  const SizedBox(height: 100),
                  Center(child: Text('Ошибка: ${snapshot.error}')),
                ],
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final cartItems = snapshot.data!;

            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Image.network(
                      cartItem.product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(cartItem.product.name),
                    subtitle: Column(
                      children: [
                        Text('${cartItem.product.price} RUB'),
                        Text('Added: ${cartItem.addedQuantity}'),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        try {
                          await CartitemApiService.removeFromCart(
                              cartItem.idCartItem, 1);
                          refreshCartItems();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Ошибка при добавлении: $e')),
                          );
                        }
                      },
                      icon: const Icon(Icons.exposure_minus_1),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}