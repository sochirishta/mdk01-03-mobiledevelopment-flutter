import 'dart:convert';
import 'package:frontend/api_config.dart';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/user_session.dart';

class UserApiService {
  static final String baseUrl = ApiConfig.baseUrl;
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };

  static Map<String, String> userBody(String username, String passwd) {
    return {'userName': username, 'userPwd': passwd};
  }

  static Future<User> sendUserRequest(
    String endpoint,
    String username,
    String passwd,
  ) async {
    final url = Uri.parse('$baseUrl/api/Users/$endpoint');

    final response = await http.post(
      url,
      headers: jsonHeaders,
      body: jsonEncode(userBody(username, passwd)),
    );

    if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));
      await UserSession.saveSession(user.idUser);
      return user;
    } else {
      throw Exception('Ошибка загрузки: ${response.body}');
    }
  }

  static Future<User> signIn(String username, String passwd) async {
    return sendUserRequest('login', username, passwd);
  }

  static Future<User> signUp(String username, String passwd) async {
    return sendUserRequest('register', username, passwd);
  }

  static Future<void> deleteUser(int id) async {
    final url = Uri.parse('$baseUrl/api/Users/$id');
    final response = await http.delete(url);
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Ошибка удаления: ${response.body}');
    }
    await UserSession.removeSession();
  }

  static Future<User> editUser(int id, String username, String passwd) async {
    final url = Uri.parse('$baseUrl/api/Users/$id');
    final response = await http.put(
      url,
      headers: jsonHeaders,
      body: jsonEncode(userBody(username, passwd)),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ошибка загрузки: ${response.body}');
    }
  }

  static Future<User> getUser(int id) async {
    final url = Uri.parse('$baseUrl/api/Users/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Ошибка загрузки: ${response.statusCode}');
    }
  }
}
