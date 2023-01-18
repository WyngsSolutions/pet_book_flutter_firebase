import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  //Singleton pattern
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {

    //Initialization Settings for Android
    final AndroidInitializationSettings initializationSettingsAndroid = 
      AndroidInitializationSettings('app_icon');

    //Initialization Settings for iOS 
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    final InitializationSettings initializationSettings =
      InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS
      );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings, 
      //onSelectNotification: selectNotification
    );
  }

  Future selectNotification(String payload) async {
    // await Navigator.push(
    //   Get.context!,
    //   MaterialPageRoute<void>(builder: (context) => CalendarScreen(allTasks: [])),
    // );
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
}