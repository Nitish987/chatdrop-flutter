import 'package:chatdrop/shared/models/notification_model/notification_model.dart';

abstract class NotifierState {}

class LoadingNotificationListState extends NotifierState {}

class NotificationListState extends NotifierState {
  List<NotificationModel> notifications;
  bool hasNext;
  NotificationListState({required this.notifications, this.hasNext = false});
}

class FailedNotificationListState extends NotifierState {
  String error;
  FailedNotificationListState(this.error);
}
