import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class ApiClient {
  static const String baseUrl =
      'https://magenagoftam.ir/api';

  // --------------------------------------------------
  // GET
  // --------------------------------------------------

  static Future<http.Response> get(
    String endpoint,
  ) async {
    final token = await _getToken();

    return http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers(token),
    );
  }

  // --------------------------------------------------
  // POST JSON
  // --------------------------------------------------

  static Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final token = await _getToken();

    return http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers(token),
      body: body == null ? null : jsonEncode(body),
    );
  }

  // --------------------------------------------------
  // POST FORM
  // --------------------------------------------------

  static Future<http.Response> postForm(
    String endpoint, {
    required Map<String, String> body,
  }) async {
    final token = await _getToken();

    return http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _formHeaders(token),
      body: body,
    );
  }

  // --------------------------------------------------
  // PUT JSON
  // --------------------------------------------------

  static Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final token = await _getToken();

    return http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers(token),
      body: body == null ? null : jsonEncode(body),
    );
  }

  // --------------------------------------------------
  // DELETE JSON
  // --------------------------------------------------

  static Future<http.Response> delete(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final token = await _getToken();

    return http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers(token),
      body: body == null ? null : jsonEncode(body),
    );
  }

  // --------------------------------------------------
  // Token
  // --------------------------------------------------

  static Future<String?> _getToken() async {
    /*
     * Flutter Web:
     * Authentication is handled by the HttpOnly cookie.
     *
     * Therefore the token must NOT be read from
     * SharedPreferences and must NOT be sent manually.
     */
    if (kIsWeb) {
      return null;
    }

    /*
     * Android / iOS:
     * Continue using the Bearer token stored by
     * AuthService.
     */
    return AuthService.getToken();
  }

  // --------------------------------------------------
  // JSON Headers
  // --------------------------------------------------

  static Map<String, String> _headers(
    String? token,
  ) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // --------------------------------------------------
  // Form Headers
  // --------------------------------------------------

  static Map<String, String> _formHeaders(
    String? token,
  ) {
    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}