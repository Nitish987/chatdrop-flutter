import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const AndroidInitializationSettings _androidInitializationSettings = AndroidInitializationSettings('logo');
  static bool _isInitialized = false;

  static void initialize() async {
    if(!_isInitialized) {
      InitializationSettings initializationSettings = const InitializationSettings(
          android: _androidInitializationSettings
      );
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
      _isInitialized = true;
    }
  }

  static void push(int id, String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'CHATDROP15',
      'CHATDROP_MESSAGING_SERVICE',
      priority: Priority.high,
      importance: Importance.max,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails);
  }

  static void cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static void cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}