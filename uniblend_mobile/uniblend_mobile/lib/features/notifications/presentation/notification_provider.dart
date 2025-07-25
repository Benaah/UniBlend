import 'package:flutter/foundation.dart';
import '../../../shared/models/notification.dart';
import '../../../shared/services/notification_service.dart';
import '../../../shared/services/local_notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final LocalNotificationService _localNotificationService = LocalNotificationService();

  List<AppNotification> _notifications = [];
  List<Activity> _activities = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  Map<String, bool> _preferences = {};

  // Pagination
  int _currentPage = 1;
  bool _hasMoreNotifications = true;
  int _activityPage = 1;
  bool _hasMoreActivities = true;

  // Getters
  List<AppNotification> get notifications => _notifications;
  List<Activity> get activities => _activities;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  Map<String, bool> get preferences => _preferences;
  bool get hasMoreNotifications => _hasMoreNotifications;
  bool get hasMoreActivities => _hasMoreActivities;

  // Filtered notifications
  List<AppNotification> get unreadNotifications => 
      _notifications.where((n) => !n.isRead).toList();

  List<AppNotification> get readNotifications => 
      _notifications.where((n) => n.isRead).toList();

  Future<void> initialize() async {
    await _localNotificationService.initialize();
    await loadNotifications();
    await loadUnreadCount();
    await loadPreferences();
  }

  // Load notifications with pagination
  Future<void> loadNotifications({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMoreNotifications = true;
      _notifications.clear();
    }

    if (!_hasMoreNotifications) return;

    _setLoading(refresh);
    _clearError();

    final response = await _notificationService.getNotifications(
      page: _currentPage,
      limit: 20,
    );

    response.fold(
      onSuccess: (newNotifications) {
        if (refresh) {
          _notifications = newNotifications;
        } else {
          _notifications.addAll(newNotifications);
        }

        _hasMoreNotifications = newNotifications.length == 20;
        _currentPage++;
        _setLoading(false);
      },
      onError: (error) {
        _setError(error);
        _setLoading(false);
      },
    );
  }

  // Load more notifications
  Future<void> loadMoreNotifications() async {
    if (_isLoadingMore || !_hasMoreNotifications) return;

    _isLoadingMore = true;
    notifyListeners();

    final response = await _notificationService.getNotifications(
      page: _currentPage,
      limit: 20,
    );

    response.fold(
      onSuccess: (newNotifications) {
        _notifications.addAll(newNotifications);
        _hasMoreNotifications = newNotifications.length == 20;
        _currentPage++;
      },
      onError: (error) {
        _setError(error);
      },
    );

    _isLoadingMore = false;
    notifyListeners();
  }

  // Mark notification as read
  Future<void> markAsRead(int notificationId) async {
    final response = await _notificationService.markAsRead(notificationId);

    response.fold(
      onSuccess: (_) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(
            isRead: true,
            readAt: DateTime.now(),
          );
          _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
          notifyListeners();
        }
      },
      onError: (error) {
        _setError(error);
      },
    );
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    final response = await _notificationService.markAllAsRead();

    response.fold(
      onSuccess: (_) {
        _notifications = _notifications.map((n) => n.copyWith(
          isRead: true,
          readAt: DateTime.now(),
        )).toList();
        _unreadCount = 0;
        notifyListeners();
      },
      onError: (error) {
        _setError(error);
      },
    );
  }

  // Delete notification
  Future<void> deleteNotification(int notificationId) async {
    final response = await _notificationService.deleteNotification(notificationId);

    response.fold(
      onSuccess: (_) {
        final notification = _notifications.firstWhere((n) => n.id == notificationId);
        if (!notification.isRead) {
          _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
        }
        _notifications.removeWhere((n) => n.id == notificationId);
        notifyListeners();
      },
      onError: (error) {
        _setError(error);
      },
    );
  }

  // Load unread count
  Future<void> loadUnreadCount() async {
    final response = await _notificationService.getUnreadCount();

    response.fold(
      onSuccess: (count) {
        _unreadCount = count;
        _localNotificationService.setBadgeCount(count);
        notifyListeners();
      },
      onError: (error) {
        // Silently fail for unread count
        debugPrint('Failed to load unread count: $error');
      },
    );
  }

  // Load activities
  Future<void> loadActivities({bool refresh = false}) async {
    if (refresh) {
      _activityPage = 1;
      _hasMoreActivities = true;
      _activities.clear();
    }

    if (!_hasMoreActivities) return;

    _setLoading(refresh);

    final response = await _notificationService.getActivities(
      page: _activityPage,
      limit: 20,
    );

    response.fold(
      onSuccess: (newActivities) {
        if (refresh) {
          _activities = newActivities;
        } else {
          _activities.addAll(newActivities);
        }

        _hasMoreActivities = newActivities.length == 20;
        _activityPage++;
        _setLoading(false);
      },
      onError: (error) {
        _setError(error);
        _setLoading(false);
      },
    );
  }

  // Load more activities
  Future<void> loadMoreActivities() async {
    if (_isLoadingMore || !_hasMoreActivities) return;

    _isLoadingMore = true;
    notifyListeners();

    final response = await _notificationService.getActivities(
      page: _activityPage,
      limit: 20,
    );

    response.fold(
      onSuccess: (newActivities) {
        _activities.addAll(newActivities);
        _hasMoreActivities = newActivities.length == 20;
        _activityPage++;
      },
      onError: (error) {
        _setError(error);
      },
    );

    _isLoadingMore = false;
    notifyListeners();
  }

  // Create activity log
  Future<void> logActivity({
    required String type,
    required String action,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    await _notificationService.createActivity(
      type: type,
      action: action,
      description: description,
      metadata: metadata,
    );
  }

  // Load notification preferences
  Future<void> loadPreferences() async {
    final response = await _notificationService.getNotificationPreferences();

    response.fold(
      onSuccess: (prefs) {
        _preferences = prefs;
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Failed to load preferences: $error');
      },
    );
  }

  // Update notification preferences
  Future<void> updatePreferences({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? threadNotifications,
    bool? bookingNotifications,
    bool? socialNotifications,
  }) async {
    final response = await _notificationService.updateNotificationPreferences(
      emailNotifications: emailNotifications,
      pushNotifications: pushNotifications,
      threadNotifications: threadNotifications,
      bookingNotifications: bookingNotifications,
      socialNotifications: socialNotifications,
    );

    response.fold(
      onSuccess: (_) {
        // Update local preferences
        if (emailNotifications != null) {
          _preferences['email_notifications'] = emailNotifications;
        }
        if (pushNotifications != null) {
          _preferences['push_notifications'] = pushNotifications;
        }
        if (threadNotifications != null) {
          _preferences['thread_notifications'] = threadNotifications;
        }
        if (bookingNotifications != null) {
          _preferences['booking_notifications'] = bookingNotifications;
        }
        if (socialNotifications != null) {
          _preferences['social_notifications'] = socialNotifications;
        }
        notifyListeners();
      },
      onError: (error) {
        _setError(error);
      },
    );
  }

  // Show local notification
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    NotificationCategory category = NotificationCategory.general,
  }) async {
    await _localNotificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      payload: payload,
      category: category,
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear all data (for logout)
  void clear() {
    _notifications.clear();
    _activities.clear();
    _unreadCount = 0;
    _preferences.clear();
    _currentPage = 1;
    _activityPage = 1;
    _hasMoreNotifications = true;
    _hasMoreActivities = true;
    _isLoading = false;
    _isLoadingMore = false;
    _error = null;
    notifyListeners();
  }
}
