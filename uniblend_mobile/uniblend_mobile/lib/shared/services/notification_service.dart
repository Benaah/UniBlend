import '../models/notification.dart';
import '../models/api_response.dart';
import 'api_service.dart';
import '../../core/config/api_config.dart';

class NotificationService {
  final ApiService _apiService = ApiService();

  // Get all notifications for the current user
  Future<ApiResponse<List<AppNotification>>> getNotifications({
    int page = 1,
    int limit = 20,
    bool? unreadOnly,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (unreadOnly != null) {
      queryParams['unread_only'] = unreadOnly.toString();
    }

    final response = await _apiService.get<List<dynamic>>(
      ApiConfig.notificationsEndpoint,
      queryParams: queryParams,
    );

    return response.fold(
      onSuccess: (data) {
        final notifications = data
            .map((json) => AppNotification.fromJson(json as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(notifications);
      },
      onError: (error) => ApiResponse.error(error),
    );
  }

  // Mark notification as read
  Future<ApiResponse<void>> markAsRead(int notificationId) async {
    final response = await _apiService.put<void>(
      '${ApiConfig.notificationsEndpoint}/$notificationId/read',
    );

    return response;
  }

  // Mark all notifications as read
  Future<ApiResponse<void>> markAllAsRead() async {
    final response = await _apiService.put<void>(
      '${ApiConfig.notificationsEndpoint}/read-all',
    );

    return response;
  }

  // Delete notification
  Future<ApiResponse<void>> deleteNotification(int notificationId) async {
    final response = await _apiService.delete<void>(
      '${ApiConfig.notificationsEndpoint}/$notificationId',
    );

    return response;
  }

  // Get unread notification count
  Future<ApiResponse<int>> getUnreadCount() async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '${ApiConfig.notificationsEndpoint}/unread-count',
    );

    return response.fold(
      onSuccess: (data) {
        final count = data['count'] as int? ?? 0;
        return ApiResponse.success(count);
      },
      onError: (error) => ApiResponse.error(error),
    );
  }

  // Get user activities
  Future<ApiResponse<List<Activity>>> getActivities({
    int page = 1,
    int limit = 20,
    String? type,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (type != null) {
      queryParams['type'] = type;
    }

    final response = await _apiService.get<List<dynamic>>(
      '/activities',
      queryParams: queryParams,
    );

    return response.fold(
      onSuccess: (data) {
        final activities = data
            .map((json) => Activity.fromJson(json as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(activities);
      },
      onError: (error) => ApiResponse.error(error),
    );
  }

  // Create activity (for logging user actions)
  Future<ApiResponse<Activity>> createActivity({
    required String type,
    required String action,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/activities',
      body: {
        'type': type,
        'action': action,
        'description': description,
        'metadata': metadata,
      },
    );

    return response.fold(
      onSuccess: (data) {
        final activity = Activity.fromJson(data);
        return ApiResponse.success(activity);
      },
      onError: (error) => ApiResponse.error(error),
    );
  }

  // Update notification preferences
  Future<ApiResponse<void>> updateNotificationPreferences({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? threadNotifications,
    bool? bookingNotifications,
    bool? socialNotifications,
  }) async {
    final body = <String, dynamic>{};

    if (emailNotifications != null) {
      body['email_notifications'] = emailNotifications;
    }
    if (pushNotifications != null) {
      body['push_notifications'] = pushNotifications;
    }
    if (threadNotifications != null) {
      body['thread_notifications'] = threadNotifications;
    }
    if (bookingNotifications != null) {
      body['booking_notifications'] = bookingNotifications;
    }
    if (socialNotifications != null) {
      body['social_notifications'] = socialNotifications;
    }

    final response = await _apiService.put<void>(
      '/notification-preferences',
      body: body,
    );

    return response;
  }

  // Get notification preferences
  Future<ApiResponse<Map<String, bool>>> getNotificationPreferences() async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/notification-preferences',
    );

    return response.fold(
      onSuccess: (data) {
        final preferences = Map<String, bool>.from(data);
        return ApiResponse.success(preferences);
      },
      onError: (error) => ApiResponse.error(error),
    );
  }
}
