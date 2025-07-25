import 'package:flutter/foundation.dart';
import '../../../shared/models/user.dart';
import '../../../shared/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    final response = await _authService.login(
      email: email,
      password: password,
    );

    return response.fold(
      onSuccess: (authResponse) {
        _user = authResponse.user;
        _setLoading(false);
        return true;
      },
      onError: (error) {
        _setError(error);
        _setLoading(false);
        return false;
      },
    );
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    _setLoading(true);
    _clearError();

    final response = await _authService.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    return response.fold(
      onSuccess: (authResponse) {
        _user = authResponse.user;
        _setLoading(false);
        return true;
      },
      onError: (error) {
        _setError(error);
        _setLoading(false);
        return false;
      },
    );
  }

  Future<void> logout() async {
    _setLoading(true);
    
    await _authService.logout();
    
    _user = null;
    _setLoading(false);
    _clearError();
  }

  Future<void> checkAuthStatus() async {
    if (await _authService.isLoggedIn()) {
      final response = await _authService.getCurrentUser();
      
      response.fold(
        onSuccess: (user) {
          _user = user;
          notifyListeners();
        },
        onError: (error) {
          // Token might be expired, clear it
          _authService.clearSession();
          _user = null;
          notifyListeners();
        },
      );
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
