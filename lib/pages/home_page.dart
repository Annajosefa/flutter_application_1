import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:badges/badges.dart' as badges;

import 'package:flutter_application_1/pages/parameter_page.dart';
import 'package:flutter_application_1/pages/harvest_page.dart';
import 'package:flutter_application_1/pages/notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<dynamic> harvests = [];
  double humidity = 0.0;
  double light = 0.0;
  double soil = 0.0;
  double temperature = 0.0;
  bool r1 = false;
  bool r2 = false;
  bool r3 = false;
  bool r4 = false;
  bool r5 = false;
  List<dynamic> humidityList = [];
  List<dynamic> lightList = [];
  List<dynamic> soilList = [];
  List<dynamic> temperatureList = [];

  int pageIndex = 0;

  void switchPage(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  void initState() {
    db
        .collection('parameters')
        .orderBy('created_at', descending: true)
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int unreadNotifications = 1;

    return Scaffold(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              },
            ),
          ),
          const Padding(padding: EdgeInsets.all(10))
        ],
        backgroundColor: const Color(0xFFD67BFF),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset('assets/images/logo.png'),
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
              minHeight: MediaQuery.of(context).size.height * 0.75,
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
