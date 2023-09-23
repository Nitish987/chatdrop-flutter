import 'package:chatdrop/infra/utilities/response.dart';
import 'package:chatdrop/shared/repository/notification_repo.dart';
import 'package:chatdrop/shared/models/notification_model/notification_model.dart';

class NotificationService {
  final NotificationRepository _notificationRepository = NotificationRepository.instance;

  Future<Map<String, dynamic>> fetchNotification(int page) async {
    try {
      final response =
      ResponseCollector.collect(
        await _notificationRepository.fetchNotifications(page),
      );
      if (response.success) {
        bool hasNext = response.data?['has_next'];
        List<dynamic> result = response.data?['notifications'];
        List<NotificationModel> notifications = result.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
        return {
          'notifications': notifications,
          'has_next': hasNext,
        };
      }
      return {
        'notifications': null,
        'has_next': false,
      };
    } catch (e) {
      return {
        'notifications': null,
        'has_next': false,
      };
    }
  }

  Future<bool> readNotification(int id) async {
    try {
      final response =
      ResponseCollector.collect(
        await _notificationRepository.readNotificationSignal(id),
      );
      return response.success;
    } catch (e) {
      return false;
    }
  }
}