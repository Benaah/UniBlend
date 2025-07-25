import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/api_response.dart';
import '../../core/config/api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final _storage = const FlutterSecureStorage();
  late http.Client _client;

  void init() {
    _client = http.Client();
  }

  Future<String?> getToken() async {
    return await _storage.read(key: ApiConfig.tokenKey);
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: ApiConfig.tokenKey, value: token);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: ApiConfig.tokenKey);
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, String>> get _headersWithAuth async {
    final token = await getToken();
    final headers = Map<String, String>.from(_headers);
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final uriWithQuery = queryParams != null 
          ? uri.replace(queryParameters: queryParams)
          : uri;

      final response = await _client
          .get(uriWithQuery, headers: await _headersWithAuth)
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await _client
          .post(
            uri,
            headers: await _headersWithAuth,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await _client
          .put(
            uri,
            headers: await _headersWithAuth,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await _client
          .delete(uri, headers: await _headersWithAuth)
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    final statusCode = response.statusCode;
    
    if (statusCode >= 200 && statusCode < 300) {
      try {
        final decodedBody = jsonDecode(response.body);
        
        if (fromJson != null) {
          final data = fromJson(decodedBody['data'] ?? decodedBody);
          return ApiResponse.success(data);
        } else {
          return ApiResponse.success(decodedBody as T);
        }
      } catch (e) {
        return ApiResponse.error('Failed to parse response: $e');
      }
    } else {
      try {
        final decodedBody = jsonDecode(response.body);
        final message = decodedBody['message'] ?? 'Request failed';
        return ApiResponse.error(message);
      } catch (e) {
        return ApiResponse.error('Request failed with status: $statusCode');
      }
    }
  }

  String _handleException(dynamic exception) {
    if (exception is SocketException) {
      return 'No internet connection';
    } else if (exception is HttpException) {
      return 'Server error occurred';
    } else if (exception is FormatException) {
      return 'Invalid response format';
    } else {
      return 'An unexpected error occurred: $exception';
    }
  }

  void dispose() {
    _client.close();
  }
}
