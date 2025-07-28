import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../notifications/presentation/notification_provider.dart';
import '../../../core/widgets/demo_notification_helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/profile/settings');
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.red[200],
                        child: Text(
                          user?.name.isNotEmpty == true
                              ? user!.name[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.name ?? 'User Name',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? 'user@example.com',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatItem(label: 'Posts', value: '24'),
                          _StatItem(label: 'Followers', value: '156'),
                          _StatItem(label: 'Following', value: '89'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Menu items
                _MenuSection(
                  title: 'Account',
                  items: [
                    _MenuItem(
                      icon: Icons.person,
                      title: 'Edit Profile',
                      onTap: () {
                        Navigator.of(context).pushNamed('/profile/edit');
                      },
                    ),
                    _MenuItem(
                      icon: Icons.wallet,
                      title: 'Wallet',
                      onTap: () {
                        Navigator.of(context).pushNamed('/wallet');
                      },
                    ),
                    _MenuItem(
                      icon: Icons.history,
                      title: 'Activity History',
                      onTap: () {
                        Navigator.of(context).pushNamed('/profile/activity-history');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _MenuSection(
                  title: 'Preferences',
                  items: [
                    _MenuItem(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      onTap: () {
                        Navigator.of(context).pushNamed('/profile/notifications');
                      },
                    ),
                    _MenuItem(
                      icon: Icons.privacy_tip,
                      title: 'Privacy',
                      onTap: () {
                        Navigator.of(context).pushNamed('/profile/privacy');
                      },
                    ),
                    _MenuItem(
                      icon: Icons.help,
                      title: 'Help & Support',
                      onTap: () {
                        Navigator.of(context).pushNamed('/profile/help');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _MenuSection(
                  title: 'About',
                  items: [
                    _MenuItem(
                      icon: Icons.info,
                      title: 'About UniBlend',
                      onTap: () {
                        Navigator.of(context).pushNamed('/profile/about');
                      },
                    ),
                    _MenuItem(
                      icon: Icons.description,
                      title: 'Terms & Conditions',
                      onTap: () {
                        Navigator.of(context).pushNamed('/profile/terms');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Demo section (for testing)
                _MenuSection(
                  title: 'Demo & Testing',
                  items: [
                    _MenuItem(
                      icon: Icons.science,
                      title: 'Test Notifications',
                      onTap: () => DemoNotificationHelper.createSampleData(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Logout button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await authProvider.logout();
                      // Clear notifications when logging out
                      if (context.mounted) {
                        context.read<NotificationProvider>().clear();
                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _MenuSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
