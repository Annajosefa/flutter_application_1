import 'package:flutter_local_notifications/flutter_local_notifications.dart';
 
showNotification(String title,String message) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
 
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
 
  const InitializationSettings initializationSettings =
      InitializationSettings(android: androidInitializationSettings);
 
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
 
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high channel', 'Very important notification!!',
      description: 'Kabutech', importance: Importance.max);
 
  await flutterLocalNotificationsPlugin.show(
      1,
      title,
      message,
      NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description)));
}