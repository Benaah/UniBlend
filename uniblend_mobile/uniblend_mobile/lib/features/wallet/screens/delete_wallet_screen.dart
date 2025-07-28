import 'package:flutter/material.dart';

class DeleteWalletScreen extends StatelessWidget {
  const DeleteWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Wallet')),
      body: Center(child: Text('Delete Wallet Screen')),
    );
  }
}
