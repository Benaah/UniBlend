import 'package:flutter/material.dart';

class ProfileTermsScreen extends StatelessWidget {
  const ProfileTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            Text(
              'Terms & Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'These are the terms and conditions for using UniBlend. '
              'By using this app, you agree to comply with these terms.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '1. Use of the app is at your own risk.\n'
              '2. Respect other users and their content.\n'
              '3. Do not misuse the app or its services.\n'
              '4. UniBlend reserves the right to modify these terms at any time.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
