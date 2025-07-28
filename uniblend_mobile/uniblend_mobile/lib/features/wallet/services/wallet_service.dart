import 'dart:convert';
import 'package:http/http.dart' as http;

class WalletService {
  final String baseUrl;
  final String authToken;

  WalletService({required this.baseUrl, required this.authToken});

  Future<Map<String, dynamic>> getWallet() async {
    final response = await http.get(
      Uri.parse('\$baseUrl/wallet'),
      headers: {
        'Authorization': 'Bearer \$authToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load wallet');
    }
  }

  Future<Map<String, dynamic>> deposit({
    required int userId,
    required double amount,
    required String paymentMethod,
  }) async {
    final response = await http.post(
      Uri.parse('\$baseUrl/wallet/deposit'),
      headers: {
        'Authorization': 'Bearer \$authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user_id': userId,
        'amount': amount,
        'payment_method': paymentMethod,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to deposit');
    }
  }

  Future<Map<String, dynamic>> withdraw({
    required int userId,
    required double amount,
  }) async {
    final response = await http.post(
      Uri.parse('\$baseUrl/wallet/withdraw'),
      headers: {
        'Authorization': 'Bearer \$authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user_id': userId,
        'amount': amount,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to withdraw');
    }
  }
}
