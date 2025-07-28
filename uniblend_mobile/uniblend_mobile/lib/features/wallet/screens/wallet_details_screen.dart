import 'package:flutter/material.dart';

class WalletDetailsScreen extends StatelessWidget {
  const WalletDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet Details')),
      body: Center(child: Text('Wallet Details Screen')),
    );
  }
}
