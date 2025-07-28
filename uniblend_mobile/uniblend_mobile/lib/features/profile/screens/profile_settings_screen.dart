import 'package:flutter/material.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () {
              Navigator.of(context).pushNamed('/profile/security');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notification Settings'),
            onTap: () {
              Navigator.of(context).pushNamed('/profile/notifications/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('Music Settings'),
            onTap: () {
              Navigator.of(context).pushNamed('/profile/music/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text('Gallery Settings'),
            onTap: () {
              Navigator.of(context).pushNamed('/profile/gallery/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Event Settings'),
            onTap: () {
              Navigator.of(context).pushNamed('/profile/events/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat Settings'),
            onTap: () {
              Navigator.of(context).pushNamed('/profile/chat/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.flash_on),
            title: const Text('FlashClass Settings'),
            onTap: () {
              Navigator.of(context).pushNamed('/profile/flashclass/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.miscellaneous_services),
            title: const Text('Services Settings'),
            onTap: () {
              Navigator.of(context).pushNamed('/profile/services/services');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Wallet Settings'),
            onTap: () {
              Navigator.of(context).pushNamed('/profile/wallet/settings');
            },
          ),
        ],
      ),
    );
  }
}
