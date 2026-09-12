import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

class AuthService {
  static Future<void> sendOtp({
    required String phone,
  }) async {
    final response = await ApiClient.postForm(
      'auth/send_code.php',
      body: {
        'phone': phone,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        _errorFromResponse(
          response.body,
          fallback: 'خطا در ارسال کد تأیید',
        ),
      );
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message']?.toString() ??
            'خطا در ارسال کد تأیید',
      );
    }
  }

  static Future<AuthResult> verifyOtp({
    required String phone,
    required String code,
  }) async {
    final response = await ApiClient.postForm(
      'auth/verify_code.php',
      body: {
        'phone': phone,
        'code': code,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        _errorFromResponse(
          response.body,
          fallback: 'کد تأیید نامعتبر است',
        ),
      );
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message']?.toString() ??
            'کد تأیید نامعتبر است',
      );
    }

    final data = result['data'];

    if (data is! Map) {
      throw Exception('پاسخ نامعتبر از سرور');
    }

    final token = data['token']?.toString();
    final userData = data['user'];

    if (token == null ||
        token.isEmpty ||
        userData is! Map) {
      throw Exception('پاسخ نامعتبر از سرور');
    }

    final userId = int.tryParse(
      userData['id'].toString(),
    );

    if (userId == null) {
      throw Exception('شناسه کاربر نامعتبر است');
    }

    final phoneNumber =
        userData['phone']?.toString() ?? phone;

    final firstName =
        userData['first_name']?.toString();

    final lastName =
        userData['last_name']?.toString();

    await _saveSession(
      token: token,
      userId: userId,
    );

    return AuthResult(
      token: token,
      userId: userId,
      phone: phoneNumber,
      firstName: firstName,
      lastName: lastName,
      isNewUser:
          (firstName == null || firstName.isEmpty) &&
          (lastName == null || lastName.isEmpty),
    );
  }

  static Future<void> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    final response = await ApiClient.post(
      'auth/update_profile.php',
      body: {
        'first_name': firstName,
        'last_name': lastName,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        _errorFromResponse(
          response.body,
          fallback: 'خطا در ثبت اطلاعات کاربر',
        ),
      );
    }

    final result = jsonDecode(response.body);

    if (result['success'] != true) {
      throw Exception(
        result['message']?.toString() ??
            'خطا در ثبت اطلاعات کاربر',
      );
    }
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

  static String _errorFromResponse(
    String body, {
    required String fallback,
  }) {
    try {
      final result = jsonDecode(body);

      if (result is Map &&
          result['message'] != null) {
        return result['message'].toString();
      }
    } catch (_) {}

    return fallback;
  }
}

class AuthResult {
  final String token;
  final int userId;
  final String phone;
  final String? firstName;
  final String? lastName;
  final bool isNewUser;

  const AuthResult({
    required this.token,
    required this.userId,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.isNewUser,
  });
}

