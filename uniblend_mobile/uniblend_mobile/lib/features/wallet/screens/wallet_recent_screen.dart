import 'package:flutter/material.dart';

class WalletRecentScreen extends StatelessWidget {
  const WalletRecentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recent Wallet')),
      body: Center(child: Text('Wallet Recent Screen')),
    );
  }
}
