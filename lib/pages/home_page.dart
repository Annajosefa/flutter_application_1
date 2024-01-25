import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:badges/badges.dart' as badges;

import 'package:flutter_application_1/services/appstate.dart';

import 'package:flutter_application_1/pages/parameter_page.dart';
import 'package:flutter_application_1/pages/harvest_page.dart';
import 'package:flutter_application_1/pages/notification_page.dart';

import 'package:flutter_application_1/widgets/app_drawer.dart';

class HomePage extends StatefulWidget {
  final AppState appState;
  const HomePage({
    super.key,
    required this.appState,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<dynamic> harvests = [];
  double humidity = 0.0;
  double light = 0.0;
  double soil = 0.0;
  double temperature = 0.0;
  List<dynamic> humidityList = [];
  List<dynamic> lightList = [];
  List<dynamic> soilList = [];
  List<dynamic> temperatureList = [];
  int allNotifications = 0;
  int notificationRead = 0;
  int unreadNotifications = 0;

  int pageIndex = 0;

  void switchPage(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  void initState() {
    widget.appState.database.getNotificationRead().then((value) {
      setState(() {
        notificationRead = value;
      });
    });
    db
        .collection('parameters')
        .orderBy('created_at', descending: true).limit(1)
        .snapshots()
        .listen((event) {
      FlutterLogs.logInfo(
          'Homepage', 'Firebase', 'Got ${event.docs.first.data()}');
      setState(() {
        humidity = event.docs.first.data()['humidity'].toDouble();
        light = event.docs.first.data()['light'].toDouble();
        soil = event.docs.first.data()['soil'].toDouble();
        temperature = event.docs.first.data()['temperature'].toDouble();
      });
    });
    db.collection('notifications').snapshots().listen((event) {
      allNotifications = event.docs.length;
      setState(() {
        unreadNotifications = allNotifications - notificationRead;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(
        appState: widget.appState,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Onion Sense',
          style: TextStyle(
            fontFamily: 'Roboto Condensed',
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: 2),
            badgeStyle: badges.BadgeStyle(badgeColor: Colors.red.shade400),
            badgeContent: Text(
              unreadNotifications.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.yellow,
              ),
              onPressed: () {
                widget.appState.database
                    .updateUnreadNotifications(allNotifications);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPage(),
                  ),
                );
              },
            ),
          ),
          const Padding(padding: EdgeInsets.all(10))
        ],
        backgroundColor: const Color(0xFFD67BFF),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            }, // Image tapped
            splashColor: Colors.white10, // Splash color over image
            child: Ink.image(
              fit: BoxFit.cover, // Fixes border issues
              width: 16,
              height: 16,
              image: const AssetImage('assets/images/logo.png'),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.track_changes,
            ),
            label: 'Parameters',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
            ),
            label: 'Harvests',
          ),
        ],
        backgroundColor: const Color(0xFFD67BFF),
        unselectedItemColor: Colors.grey.shade800,
        unselectedIconTheme: IconThemeData(color: Colors.grey.shade800),
        selectedItemColor: Colors.white,
        selectedIconTheme: IconThemeData(color: Colors.blue.shade800),
        currentIndex: pageIndex,
        onTap: switchPage,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 128,
            ),
            child: Column(
              children: [
                pageIndex == 0
                    ? ParameterPage(
                        humidity: humidity,
                        light: light,
                        soil: soil,
                        temperature: temperature,
                      )
                    : HarvestPage(
                        humidity: humidity,
                        light: light,
                        soil: soil,
                        temperature: temperature,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
