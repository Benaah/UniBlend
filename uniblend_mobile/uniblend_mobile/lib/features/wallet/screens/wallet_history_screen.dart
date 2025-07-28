import 'package:flutter/material.dart';
import '../services/wallet_service.dart';

class WalletHistoryScreen extends StatefulWidget {
  const WalletHistoryScreen({super.key});

  @override
  State<WalletHistoryScreen> createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen> {
  List<dynamic> _transactions = [];
  bool _loading = true;

  final WalletService walletService = WalletService(
    baseUrl: 'https://uniblend.test/api', // Replace with your API base URL
    authToken: 'your_auth_token', // Replace with actual auth token
  );

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final walletData = await walletService.getWallet();
      setState(() {
        _transactions = walletData['transaction_history'] ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      // Handle error, e.g., show snackbar
    }
  }

  Widget _buildTransactionItem(dynamic transaction) {
    final type = transaction['type'] ?? 'unknown';
    final amount = transaction['amount']?.toString() ?? '';
    final paymentMethod = transaction['payment_method'] ?? '';
    final timestamp = transaction['timestamp'] ?? '';

    return ListTile(
      title: Text('\$amount - $type'),
      subtitle: Text(paymentMethod.isNotEmpty ? 'Payment Method: $paymentMethod' : ''),
      trailing: Text(timestamp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet History')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                return _buildTransactionItem(_transactions[index]);
              },
            ),
    );
  }
}
