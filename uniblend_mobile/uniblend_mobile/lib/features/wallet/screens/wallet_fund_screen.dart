import 'package:flutter/material.dart';
import '../services/wallet_service.dart';

class WalletFundScreen extends StatefulWidget {
  const WalletFundScreen({super.key});

  @override
  State<WalletFundScreen> createState() => _WalletFundScreenState();
}

class _WalletFundScreenState extends State<WalletFundScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  String _selectedPaymentMethod = 'Mpesa';
  bool _isLoading = false;

  final WalletService walletService = WalletService(
    baseUrl: 'https://uniblend.test/api', // Replace with your API base URL
    authToken: 'your_auth_token', // Replace with actual auth token
  );

  final List<String> _paymentMethods = [
    'Mpesa',
    'Airtel Money',
    'Visa',
    'Mastercard',
    'PayPal',
  ];

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Replace with actual user ID
      int userId = 1;
      double amount = double.parse(_amountController.text);

      await walletService.deposit(
        userId: userId,
        amount: amount,
        paymentMethod: _selectedPaymentMethod,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wallet funded successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fund wallet: \$e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fund Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                items: _paymentMethods
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Payment Method'),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Fund Wallet'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
simport 'package:flutter/material.dart';

class WalletFundScreen extends StatelessWidget {
  const WalletFundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fund Wallet')),
      body: Center(child: Text('Wallet Fund Screen')),
    );
  }
}
