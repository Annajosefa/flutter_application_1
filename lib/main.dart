import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_logs/flutter_logs.dart';

import 'package:flutter_application_1/services/notification_service.dart';
import 'package:flutter_application_1/services/database.dart';

import 'package:flutter_application_1/pages/home_page.dart';

late OnionSenseDatabase database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//Initialize Logging
  await FlutterLogs.initLogs(
    logLevelsEnabled: [
      LogLevel.INFO,
      LogLevel.WARNING,
      LogLevel.ERROR,
      LogLevel.SEVERE
    ],
    timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
    directoryStructure: DirectoryStructure.FOR_DATE,
    logTypesEnabled: ["device", "network", "errors"],
    logFileExtension: LogFileExtension.LOG,
    logsWriteDirectoryName: "logs",
    logsExportDirectoryName: "logs/exported",
    debugFileOperations: true,
    isDebuggable: true,
  );

  database = OnionSenseDatabase('onionsense_test_db_1');
  await database.initializeDatabase();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showNotification(message.notification?.title ?? 'No title',
        message.notification?.body ?? 'No body');
    database.addNotification('reminder', message.notification?.title ?? 'None',
        message.notification?.body ?? 'None');
  });
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  final fcmToken = await FirebaseMessaging.instance.getToken();

  FlutterLogs.logInfo('Firebase', 'Initialization', 'FCM Key: $fcmToken');

  FirebaseFirestore db = FirebaseFirestore.instance;
  final userData = {"key": fcmToken, "subscribed": true};
  db.collection('users').doc(fcmToken).set(userData);

  runApp(const MyApp());
}

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  showNotification(
    message.notification?.title ?? 'No title',
    message.notification?.body ?? 'No body',
  );
  database.addNotification('reminder', message.notification?.title ?? 'None',
      message.notification?.body ?? 'None');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onion Sense',
      debugShowCheckedModeBanner: false,
      home: HomePage(
        database: database,
      ),
    );
  }
}
