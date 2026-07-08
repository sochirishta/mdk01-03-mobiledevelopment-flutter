import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return MyHomePage(user: snapshot.data);
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.user});

  final User? user;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _products = FirebaseFirestore.instance.collection('products');
  final _cart = FirebaseFirestore.instance.collection('carts');
  final _auth = UserLogic();
  String? _selectedPrId;
  bool _isCart = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> products = [];
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
  productsSubscription;

  void cartOpen() {
    setState(() {
      _isCart = !_isCart;
    });
  }

  @override
  void dispose() {
    productsSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    productsSubscription = _products.snapshots().listen((snapshot) {
      setState(() {
        products = snapshot.docs;
      });
    });
  }

  Future<bool> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Do you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Stay'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (ok != true) return false;
    await _auth.signOut();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _cart.doc(widget.user?.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final cart = snapshot.data?.data() ?? {};

        final Map<String, dynamic> items = Map<String, dynamic>.from(
          cart['items'] ?? {},
        );
        final user = widget.user;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(user != null ? "${user.email}" : "Guest"),
            actions: [
              if (user != null)
                IconButton(
                  onPressed: () async {
                    setState(() {
                      _isCart = false;
                      _selectedPrId = null;
                    });
                    await _logout();
                  },

                  icon: const Icon(Icons.logout),
                ),
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const LoginDialog();
                    },
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _isCart ? items.length : products.length,
                  itemBuilder: (context, index) {
                    final cartEntry;
                    final productId;
                    dynamic quantity;
                    final product;
                    if (_isCart == true) {
                      cartEntry = items.entries.elementAt(index);
                      quantity = cartEntry.value;
                      productId = cartEntry.key;
                      product = products.firstWhere(
                        (doc) => doc.id == productId,
                      );
                    } else {
                      product = products[index];
                      productId = product.id;
                    }
                    return ListTile(
                      leading: Image.network(
                        product['imageUrl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product['name']),
                      subtitle: Column(
                        children: [
                          Text("Price: ${product['Price']} RUB"),
                          Text(
                            _isCart
                                ? "Added: $quantity"
                                : "Stock in catalog: ${product['Quantity']}",
                          ),
                        ],
                      ),
                      selected: _selectedPrId == productId,
                      selectedTileColor: Colors.blue.withValues(alpha: 0.1),
                      trailing: _isCart
                          ? IconButton(
                              onPressed: (quantity ?? 0) > 0
                                  ? () =>
                                        _auth.decrementCart(productId, quantity)
                                  : null,
                              icon: const Icon(Icons.exposure_minus_1),
                            )
                          : IconButton(
                              icon: const Icon(Icons.add_shopping_cart),
                              onPressed: (product['Quantity'] ?? 0) > 0
                                  ? () => _auth.incrementCart(productId)
                                  : null,
                            ),
                      onTap: () {
                        setState(() {
                          _selectedPrId = productId;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: user != null
              ? FloatingActionButton(
                  onPressed: () => cartOpen(),
                  tooltip: 'Cart',
                  child: Icon(
                    _isCart ? Icons.cabin : Icons.shopping_cart_rounded,
                  ),
                )
              : null,
        );
      },
    );
  }
}