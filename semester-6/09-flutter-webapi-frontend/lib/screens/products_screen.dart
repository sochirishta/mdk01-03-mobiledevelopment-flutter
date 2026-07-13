import 'package:flutter/material.dart';
import 'package:frontend/screens/cart_dialog.dart';
import 'package:frontend/screens/edituser_dialog.dart';
import 'package:frontend/screens/sign_dialog.dart';
import 'package:frontend/services/user_api_service.dart';
import '../models/product_model.dart';
import '../services/product_api_service.dart';
import '../models/user_model.dart';
import 'package:frontend/main.dart';
import 'package:frontend/user_session.dart';

class ProductsScreen extends StatefulWidget {
  final int? userId;

  const ProductsScreen({super.key, required this.userId});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<Product>> futureProducts;
  late int? _currentUserId;

  @override
  void initState() {
    super.initState();
    futureProducts = ProductApiService.getProducts();
    _currentUserId = (widget.userId == 0) ? null : widget.userId;
  }

  Future<void> refreshProducts() async {
    setState(() {
      futureProducts = ProductApiService.getProducts();
    });
    await futureProducts;
  }

  void _openAuthDialog(int id) async {
    final User? user = await showDialog<User?>(
      context: context,
      builder: (context) {
        return SignDialog(userId: _currentUserId ?? 0);
      },
    );
    if (user != null) {
      setState(() {
        _currentUserId = user.idUser;
        futureProducts = ProductApiService.getProducts();
      });
    }
  }

  void _settingDialog(int id) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Настройки"),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200, maxWidth: 200),
            child: const Text("Выберите действие"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Назад"),
            ),
            TextButton(
              onPressed: () async {
                showDialog(
                  context: context,

                  builder: (context) => EdituserDialog(userId: _currentUserId!),
                );
              },

              child: const Text("Редактировать профиль"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await UserApiService.deleteUser(id);
                  setState(() {
                    _currentUserId = null;
                  });
                  futureProducts = ProductApiService.getProducts();
                  await UserSession.removeSession();
                  Navigator.pop(context);
                } catch (e) {
                  throw e;
                }
              },
              child: const Text("Удалить профиль"),
            ),
            TextButton(
              onPressed: () async {
                await UserSession.removeSession();
                setState(() {
                  _currentUserId = null;
                  futureProducts = ProductApiService.getProducts();
                });
                Navigator.pop(context);
              },
              child: const Text("Выйти из профиля"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("ТЕКУЩИЙ ID НА ЭКРАНЕ: >>> $_currentUserId <<<");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        centerTitle: true,
        actions: [
          if (_currentUserId != null && _currentUserId != 0) ...[
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartDialog(userId: _currentUserId!),
                  ),
                );
                refreshProducts();
              },
              icon: const Icon(Icons.shopping_cart_rounded),
            ),
            IconButton(
              onPressed: () => _settingDialog(_currentUserId ?? 0),
              icon: const Icon(Icons.settings),
            ),
          ],
          IconButton(
            onPressed: () => _openAuthDialog(_currentUserId ?? 0),
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshProducts,
        child: FutureBuilder<List<Product>>(
          future: futureProducts,
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

            final products = snapshot.data!;

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Card(
                  key: ValueKey(product.id_product),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Image.network(
                      product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.name),
                    subtitle: Column(
                      children: [
                        Text('${product.price} RUB'),
                        Text('Stock: ${product.quantity}'),
                      ],
                    ),
                    trailing: _currentUserId != null
                        ? IconButton(
                            onPressed: () async {
                              try {
                                await ProductApiService.addToCart(
                                  _currentUserId ?? 0,
                                  product.id_product,
                                  1,
                                );
                                refreshProducts();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Ошибка при добавлении: $e'),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.add_shopping_cart),
                          )
                        : null,
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
