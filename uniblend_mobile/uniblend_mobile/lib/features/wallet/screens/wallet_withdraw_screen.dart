import 'package:flutter/material.dart';

class WalletWithdrawScreen extends StatelessWidget {
  const WalletWithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Withdraw from Wallet')),
      body: Center(child: Text('Wallet Withdraw Screen')),
    );
  }
}
