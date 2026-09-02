import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl =
      'http://localhost/begir_api/api';

  static Future<bool> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login.php'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      return false;
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      return false;
    }

    await _saveSession(
      token: result['data']['token'],
      userId: result['data']['user_id'],
    );

    return true;
  }

  static Future<bool> register({
    required String phone,
    required String firstName,
    required String lastName,
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register.php'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      return false;
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      return false;
    }

    await _saveSession(
      token: result['data']['token'],
      userId: result['data']['user_id'],
    );

    return true;
  }

  static Future<void> _saveSession({
    required String token,
    required int userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
    await prefs.setInt('user_id', userId);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();

    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('user_id');
  }
}