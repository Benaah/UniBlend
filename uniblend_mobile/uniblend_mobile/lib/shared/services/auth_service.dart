import '../models/user.dart';
import '../models/api_response.dart';
import 'api_service.dart';
import '../../core/config/api_config.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<ApiResponse<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      ApiConfig.loginEndpoint,
      body: {
        'email': email,
        'password': password,
      },
    );

    return response.fold(
      onSuccess: (data) {
        final authResponse = AuthResponse.fromJson(data);
        // Store token for future requests
        _apiService.setToken(authResponse.token);
        return ApiResponse.success(authResponse);
      },
      onError: (error) => ApiResponse.error(error),
    );
  }

  Future<ApiResponse<AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      ApiConfig.registerEndpoint,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    return response.fold(
      onSuccess: (data) {
        final authResponse = AuthResponse.fromJson(data);
        // Store token for future requests
        _apiService.setToken(authResponse.token);
        return ApiResponse.success(authResponse);
      },
      onError: (error) => ApiResponse.error(error),
    );
  }

  Future<ApiResponse<void>> logout() async {
    final response = await _apiService.post<void>(ApiConfig.logoutEndpoint);
    
    // Clear token regardless of response
    await _apiService.clearToken();
    
    return response;
  }

  Future<ApiResponse<User>> getCurrentUser() async {
    final response = await _apiService.get<User>(
      ApiConfig.userEndpoint,
      fromJson: (json) => User.fromJson(json),
    );

    return response;
  }

  Future<bool> isLoggedIn() async {
    final token = await _apiService.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearSession() async {
    await _apiService.clearToken();
  }
}

class AuthResponse {
  final String token;
  final User user;

  AuthResponse({
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }
}
