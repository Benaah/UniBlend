import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notification_provider.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Load preferences when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Push Notifications Section
              _SettingsSection(
                title: 'Push Notifications',
                subtitle: 'Receive notifications on your device',
                children: [
                  _SettingsTile(
                    title: 'Enable Push Notifications',
                    subtitle: 'Allow the app to send push notifications',
                    value: provider.preferences['push_notifications'] ?? true,
                    onChanged: (value) {
                      provider.updatePreferences(pushNotifications: value);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Email Notifications Section
              _SettingsSection(
                title: 'Email Notifications',
                subtitle: 'Receive notifications via email',
                children: [
                  _SettingsTile(
                    title: 'Enable Email Notifications',
                    subtitle: 'Get important updates via email',
                    value: provider.preferences['email_notifications'] ?? true,
                    onChanged: (value) {
                      provider.updatePreferences(emailNotifications: value);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Content Notifications Section
              _SettingsSection(
                title: 'Content Notifications',
                subtitle: 'Choose what you want to be notified about',
                children: [
                  _SettingsTile(
                    title: 'Thread Notifications',
                    subtitle: 'New threads and replies in your followed topics',
                    value: provider.preferences['thread_notifications'] ?? true,
                    onChanged: (value) {
                      provider.updatePreferences(threadNotifications: value);
                    },
                  ),
                  _SettingsTile(
                    title: 'Social Notifications',
                    subtitle: 'Likes, comments, and follows on your content',
                    value: provider.preferences['social_notifications'] ?? true,
                    onChanged: (value) {
                      provider.updatePreferences(socialNotifications: value);
                    },
                  ),
                  _SettingsTile(
                    title: 'Booking Notifications',
                    subtitle: 'Updates about your service bookings',
                    value: provider.preferences['booking_notifications'] ?? true,
                    onChanged: (value) {
                      provider.updatePreferences(bookingNotifications: value);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Notification Management
              _SettingsSection(
                title: 'Manage Notifications',
                subtitle: 'Clear and manage your notifications',
                children: [
                  ListTile(
                    leading: const Icon(Icons.mark_email_read),
                    title: const Text('Mark All as Read'),
                    subtitle: Text(
                      '${provider.unreadCount} unread notifications',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: provider.unreadCount > 0
                        ? () => _showMarkAllReadDialog(context, provider)
                        : null,
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_sweep),
                    title: const Text('Clear All Notifications'),
                    subtitle: Text(
                      'Remove all notifications from your list',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: provider.notifications.isNotEmpty
                        ? () => _showClearAllDialog(context, provider)
                        : null,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Test Notifications (for development)
              if (provider.preferences['push_notifications'] == true) ...[
                _SettingsSection(
                  title: 'Test Notifications',
                  subtitle: 'Test your notification settings',
                  children: [
                    ListTile(
                      leading: const Icon(Icons.notifications_active),
                      title: const Text('Send Test Notification'),
                      subtitle: Text(
                        'Test if notifications are working properly',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: const Icon(Icons.send),
                      onTap: () => _sendTestNotification(provider),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // Info Section
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          Text(
                            'About Notifications',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Notifications help you stay updated with important activities in UniBlend. You can customize which types of notifications you receive and how you receive them.',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMarkAllReadDialog(BuildContext context, NotificationProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark All as Read'),
        content: Text(
          'Are you sure you want to mark all ${provider.unreadCount} notifications as read?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.markAllAsRead();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications marked as read'),
                ),
              );
            },
            child: const Text('Mark All Read'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, NotificationProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
          'Are you sure you want to permanently delete all notifications? This action cannot be undone.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement clear all functionality
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feature coming soon'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _sendTestNotification(NotificationProvider provider) {
    provider.showLocalNotification(
      title: 'Test Notification',
      body: 'This is a test notification from UniBlend!',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test notification sent!'),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).primaryColor,
    );
  }
}
