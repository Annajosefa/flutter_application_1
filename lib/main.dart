import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/services/notification_service.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/services/appstate.dart';

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

  database = OnionSenseDatabase('onionsense_test_db_3');
  await database.initializeDatabase();
  Map<String, dynamic> settings = await database.loadSettings();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showNotification(message.notification?.title ?? 'No title',
        message.notification?.body ?? 'No body');
  });
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  final fcmToken = await FirebaseMessaging.instance.getToken();

  FlutterLogs.logInfo('Firebase', 'Initialization', 'FCM Key: $fcmToken');

  FirebaseFirestore db = FirebaseFirestore.instance;
  final userData = {"key": fcmToken, "subscribed": true};
  db.collection('users').doc(fcmToken).set(userData);

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(
        database: database,
        settings: settings,
      ),
    ),
  );
}

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  showNotification(
    message.notification?.title ?? 'No title',
    message.notification?.body ?? 'No body',
  );
}

class MyApp extends StatefulWidget {
  final OnionSenseDatabase database;
  final Map<String, dynamic> settings;
  const MyApp({
    super.key,
    required this.database,
    required this.settings,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool setupDone = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    if (!setupDone) {
      appState.initializeDatabase(widget.database);
      appState.initializeSettings(widget.settings);
      setupDone = true;
    }
    return MaterialApp(
      title: 'Onion Sense',
      debugShowCheckedModeBanner: false,
      home: HomePage(
        appState: appState,
      ),
    );
  }
}
