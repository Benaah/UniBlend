import 'package:flutter/material.dart';

class ProfileHelpScreen extends StatelessWidget {
  const ProfileHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Help'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ExpansionTile(
            title: const Text('How do I edit my profile?'),
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Go to the Edit Profile screen from your profile page.'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('How do I change my password?'),
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Go to Profile Settings and select Change Password.'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('How do I contact support?'),
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Use the Support screen accessible from the profile menu.'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/profile/support');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Contact Support'),
          ),
        ],
      ),
    );
  }
}
