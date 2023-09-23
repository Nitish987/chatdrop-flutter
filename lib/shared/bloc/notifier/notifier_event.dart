import 'package:chatdrop/shared/models/notification_model/notification_model.dart';

abstract class NotifierEvent {}

class ListNotificationEvent extends NotifierEvent {
  int page;
  ListNotificationEvent({this.page = 1});
}

class AppendNotificationEvent extends NotifierEvent {
  NotificationModel notification;
  AppendNotificationEvent(this.notification);
}