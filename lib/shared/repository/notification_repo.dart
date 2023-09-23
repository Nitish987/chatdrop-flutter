import 'package:chatdrop/infra/services/api_client.dart';
import 'package:chatdrop/shared/services/user_service.dart';

class NotificationRepository {
  static final _apiClient = ApiClient.instance;
  static final instance = NotificationRepository._();

  NotificationRepository._() {
    _apiClient.attachHeaders(UserService.authHeaders);
  }

  Future<Map<String, dynamic>?> fetchNotifications(int page) async {
    final response = await _apiClient.get(
      path: 'notifier/v2/notifications/',
      queryParams: {'page': page}
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> readNotificationSignal(int id) async {
    final response = await _apiClient.put(
      path: 'notifier/v1/notification/read/',
      data: {'id': id},
    );
    return response.data;
  }
}