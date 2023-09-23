import 'package:chatdrop/shared/services/notification_service.dart';

class NotificationController {
  final NotificationService _notificationService = NotificationService();

  void setNotificationRead(int id) async {
    await _notificationService.readNotification(id);
  }
}