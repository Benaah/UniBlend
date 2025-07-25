import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/notifications/presentation/notification_provider.dart';
import '../../shared/services/local_notification_service.dart';

class DemoNotificationHelper {
  static void showDemoNotifications(BuildContext context) {
    final notificationProvider = context.read<NotificationProvider>();
    
    // Simulate different types of notifications
    final demoNotifications = [
      {
        'title': 'New Thread Reply',
        'body': 'Someone replied to your thread about Mobile Development',
        'category': NotificationCategory.thread,
      },
      {
        'title': 'Post Liked',
        'body': 'Your post got 5 new likes!',
        'category': NotificationCategory.social,
      },
      {
        'title': 'Booking Confirmed',
        'body': 'Your campus shuttle booking for 3:00 PM has been confirmed',
        'category': NotificationCategory.booking,
      },
      {
        'title': 'System Update',
        'body': 'UniBlend has been updated with new features',
        'category': NotificationCategory.system,
      },
    ];

    // Show local notifications
    for (int i = 0; i < demoNotifications.length; i++) {
      final notification = demoNotifications[i];
      
      Future.delayed(Duration(seconds: i * 2), () {
        notificationProvider.showLocalNotification(
          title: notification['title'] as String,
          body: notification['body'] as String,
          category: notification['category'] as NotificationCategory,
        );
      });
    }

    // Log activity
    notificationProvider.logActivity(
      type: 'demo',
      action: 'test_notifications',
      description: 'User tested notification system',
      metadata: {'count': demoNotifications.length},
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${demoNotifications.length} demo notifications will appear over the next ${demoNotifications.length * 2} seconds'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void createSampleData(BuildContext context) {
    final notificationProvider = context.read<NotificationProvider>();
    
    // This would normally come from the server, but for demo purposes
    // we're showing how the system would work
    notificationProvider.logActivity(
      type: 'profile',
      action: 'view_sample',
      description: 'User viewed sample notification data',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Demo Data'),
        content: const Text(
          'In a real app, notifications would be received from your Laravel backend via API calls and push notifications. '
          'This demo shows how the UI components work with local notifications.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              showDemoNotifications(context);
            },
            child: const Text('Test Notifications'),
          ),
        ],
      ),
    );
  }
}
