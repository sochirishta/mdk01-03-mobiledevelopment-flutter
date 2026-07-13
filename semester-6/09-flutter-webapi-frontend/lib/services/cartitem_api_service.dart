import 'dart:convert';
import 'package:frontend/api_config.dart';
import 'package:http/http.dart' as http;
import '../models/cartItem_model.dart';

class CartitemApiService {
  static final String baseUrl = ApiConfig.baseUrl;

  static Future<List<CartItem>> getCartItems(int idUser) async {
    final url = Uri.parse('$baseUrl/api/CartItems/user/$idUser');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((cartItem) => CartItem.fromJson(cartItem)).toList();
    } else {
      throw Exception('Ошибка загрузки: ${response.statusCode}');
    }
  }

  static Future<dynamic> removeFromCart(int idCartItem, int addedQuantity) async {
    final url = Uri.parse('$baseUrl/api/CartItems/$idCartItem?quantity=$addedQuantity',);

    final response = await http.delete(url);
    if (response.statusCode != 204)
      throw Exception('Ошибка загрузки: $response.body');
  }

}