import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool loaded = false;
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    db
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        notifications.add(docSnapshot.data());
      }
      setState(() {
        loaded = true;
      });
    });
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
            : const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFD67BFF),
                ),
              ),
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
  Widget build(BuildContext context) {
    print(widget.notifications);
    if (widget.notifications.isEmpty) {
      return const Center(
        child: Text(
          'No Notifications Yet!',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        IconData icon = Icons.error;
        String title = '';
        String content = widget.notifications[index]['content'];
        DateTime dateTime = widget.notifications[index]['created_at'].toDate();
        if (widget.notifications[index]['genre'] == 'reminder') {
          icon = Icons.local_florist;
          title = 'A row is ready to be harvested';
        } else if (widget.notifications[index]['genre'] == 'harvest') {
          icon = Icons.grass;
          title = 'A new harvest has arrived!';
        }
        return ListTile(
          isThreeLine: true,
          leading: Icon(
            icon,
            color: const Color(0xFFD67BFF),
            size: 28,
          ),
          title: Text(title),
          subtitle: Text(
            '$content\n${DateFormat.yMMMEd().add_jms().format(dateTime)}',
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: widget.notifications.length,
    );
  }
}
