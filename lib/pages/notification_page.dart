import 'package:flutter/material.dart';

import 'package:flutter_application_1/services/database.dart';

class NotificationPage extends StatefulWidget {
  final OnionSenseDatabase database;
  const NotificationPage({
    super.key,
    required this.database,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool loaded = false;
  List<Map<String, dynamic>> notifications = [{}];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFD67BFF),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Roboto Condensed',
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: loaded
            ? NotificationMainPage(
                notifications: notifications,
              )
            : const CircularProgressIndicator(color: Color(0xFFD67BFF)),
      ),
    );
  }
}

class NotificationMainPage extends StatefulWidget {
  final List<Map<String, dynamic>> notifications;
  const NotificationMainPage({
    super.key,
    required this.notifications,
  });

  @override
  State<NotificationMainPage> createState() => _NotificationMainPageState();
}

class _NotificationMainPageState extends State<NotificationMainPage> {
  int notificationsToday = 0;
  int notificationsYesterday = 0;
  int otherNotifications = 0;

  @override
  void initState() {
    getNotificationsCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(),
      ),
    );
  }

  void getNotificationsCount() {
    int tempNotificationsToday = 0;
    int tempNotificationsYesterday = 0;
    DateTime tempDate = DateTime.now();
    DateTime dateToday =
        DateTime(tempDate.year, tempDate.month, tempDate.day, 0, 0, 0);
    DateTime dateYesterday = dateToday.subtract(const Duration(days: 1));
    for (var item in widget.notifications) {
      DateTime dateTime = DateTime.parse(item['created_at']);
      if (dateTime.isAfter(dateToday)) {
        tempNotificationsToday += 1;
      } else if (dateTime.isAfter(dateYesterday)) {
        tempNotificationsYesterday += 1;
      } else {
        // Assumes that notifications are arranged by created date
        break;
      }
    }
    int tempOtherNotifications = widget.notifications.length -
        (tempNotificationsToday + tempNotificationsYesterday);

    setState(() {
      notificationsToday = tempNotificationsToday;
      notificationsYesterday = tempNotificationsYesterday;
      otherNotifications = tempOtherNotifications;
    });
  }
}
