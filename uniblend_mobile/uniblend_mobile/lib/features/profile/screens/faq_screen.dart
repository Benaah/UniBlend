import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ExpansionTile(
            title: Text('How do I reset my password?'),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Go to Profile Settings and select Change Password.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How do I delete my account?'),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Go to Delete Account screen from your profile menu.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How do I contact support?'),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Use the Support screen accessible from the profile menu.'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
