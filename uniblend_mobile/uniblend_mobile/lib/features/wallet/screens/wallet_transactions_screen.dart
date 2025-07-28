import 'package:flutter/material.dart';

class WalletTransactionsScreen extends StatelessWidget {
  const WalletTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet Transactions')),
      body: Center(child: Text('Wallet Transactions Screen')),
    );
  }
}
