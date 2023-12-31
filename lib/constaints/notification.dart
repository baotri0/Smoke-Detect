import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
    const AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings =
    InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showBigTextNotification(
      {var id = 0,
        required String title,
        required String body,
        var payload,
        required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails(
      "you_can_name_it_whatever1",
      "channel_name",
      playSound: true,
      //sound: RawResourceAndroidNotificationSound('warning.mp3'),
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidNotificationDetails,iOS: const DarwinNotificationDetails());

    await fln.show(0, title, body, not);
  }
}
