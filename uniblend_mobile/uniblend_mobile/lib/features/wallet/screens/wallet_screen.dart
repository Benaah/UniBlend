import 'package:flutter/material.dart';
import '../services/wallet_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double _balance = 0.0;
  bool _loading = true;
  final WalletService walletService = WalletService(
    baseUrl: 'https://uniblend.test/api', // Replace with your API base URL
    authToken: 'your_auth_token', // Replace with actual auth token
  );

  @override
  void initState() {
    super.initState();
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    try {
      final walletData = await walletService.getWallet();
      setState(() {
        _balance = walletData['balance']?.toDouble() ?? 0.0;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      // Handle error, e.g., show snackbar
    }
  }

  void _navigateToFundWallet() {
    Navigator.pushNamed(context, '/wallet/fund').then((_) => _loadWallet());
  }

  void _navigateToHistory() {
    Navigator.pushNamed(context, '/wallet/history');
  }

  void _navigateToBookRides() {
    // Implement navigation to book rides screen
  }

  void _navigateToBookMeals() {
    // Implement navigation to book meals screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Balance: \$\$_balance', style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _navigateToBookRides,
                    child: const Text('Book Rides'),
                  ),
                  ElevatedButton(
                    onPressed: _navigateToBookMeals,
                    child: const Text('Book Meals'),
                  ),
                  ElevatedButton(
                    onPressed: _navigateToFundWallet,
                    child: const Text('Fund Wallet'),
                  ),
                  ElevatedButton(
                    onPressed: _navigateToHistory,
                    child: const Text('View History'),
                  ),
                ],
              ),
            ),
    );
  }
}
