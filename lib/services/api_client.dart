import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

import 'session_manager.dart';

class ApiClient {
  static const String baseUrl =
      'https://magenagoftam.ir/api';

  // --------------------------------------------------
  // GET
  // --------------------------------------------------

  static Future<http.Response> get(
    String endpoint, {
    bool handleUnauthorized = true,
  }) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers(token),
    );

    return _handleResponse(
      response,
      handleUnauthorized: handleUnauthorized,
    );
  }

  // --------------------------------------------------
  // POST JSON
  // --------------------------------------------------

  static Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool handleUnauthorized = true,
  }) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers(token),
      body: body == null ? null : jsonEncode(body),
    );

    return _handleResponse(
      response,
      handleUnauthorized: handleUnauthorized,
    );
  }

  // --------------------------------------------------
  // POST FORM
  // --------------------------------------------------

  static Future<http.Response> postForm(
    String endpoint, {
    required Map<String, String> body,
    bool handleUnauthorized = true,
  }) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _formHeaders(token),
      body: body,
    );

    return _handleResponse(
      response,
      handleUnauthorized: handleUnauthorized,
    );
  }

  // --------------------------------------------------
  // PUT JSON
  // --------------------------------------------------

  static Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool handleUnauthorized = true,
  }) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers(token),
      body: body == null ? null : jsonEncode(body),
    );

    return _handleResponse(
      response,
      handleUnauthorized: handleUnauthorized,
    );
  }

  // --------------------------------------------------
  // DELETE JSON
  // --------------------------------------------------

  static Future<http.Response> delete(
    String endpoint, {
    Map<String, dynamic>? body,
    bool handleUnauthorized = true,
  }) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers(token),
      body: body == null ? null : jsonEncode(body),
    );

    return _handleResponse(
      response,
      handleUnauthorized: handleUnauthorized,
    );
  }

  // --------------------------------------------------
  // Unauthorized
  // --------------------------------------------------

  static Future<http.Response> _handleResponse(
  http.Response response, {
  required bool handleUnauthorized,
}) async {
  if (response.statusCode == 401 &&
      handleUnauthorized) {
    await SessionManager.handleUnauthorized();
  }

  return response;
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
      headers['Authorization'] =
          'Bearer $token';
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
      headers['Authorization'] =
          'Bearer $token';
    }

    return headers;
  }
}