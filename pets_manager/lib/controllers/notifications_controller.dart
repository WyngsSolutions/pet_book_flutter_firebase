import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class NotificationHandler{

  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async{
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'My Reminders',
        channelDescription: 'This channel is for my reminder',
        importance: Importance.max,
        priority: Priority.high,
        icon: "app_icon",
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async{
  }

  static Future showNotification({int id = 0, String? title, String? body, String? payload}) async{
    _notifications.show(id, title, body, await _notificationDetails(), payload: payload);
  }

  static Future showScheduledNotification(int id, String? title, String? body, String? payload, DateTime scheduleDate) async{
    
    tz.initializeTimeZones(); 
    DateTime pakistanTime = DateTime.now();
    final myTime2 = TZDateTime.from(pakistanTime, getLocation('Asia/Karachi')); 
    tz.setLocalLocation(tz.getLocation('Asia/Karachi'));
    dynamic notiTime = tz.TZDateTime.from(scheduleDate, tz.local);

    print(notiTime);
   _notifications.zonedSchedule(
      id, 
      title, 
      body,
      notiTime,
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }

  static deleteLocalNotificationWithId(int notiId)
  {
    _notifications.cancel(notiId);
  }
}