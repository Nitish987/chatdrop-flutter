import 'package:chatdrop/shared/services/notification_service.dart';
import 'package:chatdrop/shared/bloc/notifier/notifier_state.dart';
import 'package:chatdrop/shared/models/notification_model/notification_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifier_event.dart';

class NotifierBloc extends Bloc<NotifierEvent, NotifierState> {
  final NotificationService _notificationService = NotificationService();
  final List<NotificationModel> _notifications = [];
  late bool _hasNext = false;

  NotifierBloc() : super(LoadingNotificationListState()) {
    listNotificationEvent();
    appendNotificationEvent();
  }

  void listNotificationEvent() {
    on<ListNotificationEvent>((event, emit) async {
      Map<String, dynamic> result = await _notificationService.fetchNotification(event.page);
      if (result['notifications'] != null) {
        if (event.page == 1) {
          _notifications.clear();
        }
        _notifications.addAll(result['notifications'] as List<NotificationModel>);
      }
      _hasNext = result['has_next'] as bool;
      emit(NotificationListState(notifications: _notifications, hasNext: _hasNext));
    });
  }

  void appendNotificationEvent() {
    on<AppendNotificationEvent>((event, emit) async {
      _notifications.insert(0, event.notification);
      emit(NotificationListState(notifications: _notifications, hasNext: _hasNext));
    });
  }
}