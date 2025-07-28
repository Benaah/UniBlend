import 'package:flutter/material.dart';

class ProfilePrivacyScreen extends StatefulWidget {
  const ProfilePrivacyScreen({super.key});

  @override
  State<ProfilePrivacyScreen> createState() => _ProfilePrivacyScreenState();
}

class _ProfilePrivacyScreenState extends State<ProfilePrivacyScreen> {
  bool _isProfilePublic = true;
  bool _showEmail = false;
  bool _showActivityStatus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Privacy'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Public Profile'),
            value: _isProfilePublic,
            onChanged: (value) {
              setState(() {
                _isProfilePublic = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Show Email'),
            value: _showEmail,
            onChanged: (value) {
              setState(() {
                _showEmail = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Show Activity Status'),
            value: _showActivityStatus,
            onChanged: (value) {
              setState(() {
                _showActivityStatus = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Note: These settings are for demonstration purposes. Implement actual privacy logic as needed.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
