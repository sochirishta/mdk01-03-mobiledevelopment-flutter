import 'dart:convert';
import 'package:frontend/api_config.dart';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductApiService {
  static final String baseUrl = ApiConfig.baseUrl;

  static Future<List<Product>> getProducts() async {

    final url = Uri.parse('$baseUrl/api/Products');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((product) => Product.fromJson(product))
          .toList();
    } else {
      throw Exception('Ошибка загрузки: ${response.statusCode}');
    }
  }
  
  static Future<dynamic> addToCart(int idUser, int idProduct, int quantity) async {
    final url = Uri.parse('$baseUrl/api/CartItems/add/$idProduct?userId=$idUser&quantity=$quantity',);

    final response = await http.post(url);

    if (response.statusCode != 200) {
      throw Exception('Ошибка загрузки: ${response.statusCode}');
    }
  }
}