import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_1/widgets/period_date_picker.dart';
import 'package:flutter_application_1/widgets/harvest_list.dart';

enum Calendar { day, week, month }

class HarvestPage extends StatefulWidget {
  final double humidity;
  final double light;
  final double soil;
  final double temperature;
  const HarvestPage({
    super.key,
    required this.humidity,
    required this.light,
    required this.soil,
    required this.temperature,
  });

  @override
  State<HarvestPage> createState() => _HarvestPageState();
}

class _HarvestPageState extends State<HarvestPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  DateTime latestHarvest = DateTime.now();
  double latestAmount = 0;
  double totalHarvestAmount = 0;
  int totalHarvestTimes = 0;
  String period = 'daily';
  Calendar calendarView = Calendar.day;
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTime initialDate = DateTime.now();
  DateTime startDate = DateTime(2000);
  DateTime endDate = DateTime(2101, 12, 31);
  List<Map<String, dynamic>> harvests = [{}];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    startDateController.text = 'January 1, 2000';
    endDateController.text = 'December 31, 2101';
    getHarvestsByPeriod('daily');
    db.collection('harvests').orderBy('created_at').snapshots().listen((event) {
      setState(() {
        latestHarvest = event.docs.last.data()['created_at'].toDate();
        latestAmount = event.docs.last.data()['amount'].toDouble();
        totalHarvestAmount = getTotalHarvestAmount(event.docs);
        totalHarvestTimes = event.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.center,
      height: 900,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/harvest_bg.png'),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 167, 68, 212),
            Color(0xFFD67BFF),
          ],
          begin: Alignment(-6.0, -4.0),
          end: Alignment(1.0, 10.0),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Container(
              height: 700,
              decoration: BoxDecoration(
                color: Colors.white60,
                border: Border.all(
                  color: Colors.grey.shade800,
                  width: 2,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      HarvestTileList(
                        title: 'Latest Harvest',
                        icon: Icons.grass,
                        firstLine: '${latestAmount.toStringAsFixed(1)}kg',
                        secondLine: DateFormat.yMMM().format(latestHarvest),
                      ),
                      HarvestTileList(
                        title: 'Total Harvest',
                        icon: Icons.grass,
                        firstLine: '${totalHarvestAmount.toStringAsFixed(0)}kg',
                        secondLine: '$totalHarvestTimes times',
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    alignment: Alignment.center,
                    child: SegmentedButton<Calendar>(
                      segments: const <ButtonSegment<Calendar>>[
                        ButtonSegment<Calendar>(
                          value: Calendar.day,
                          label: Text('Day'),
                          icon: Icon(Icons.calendar_view_day),
                        ),
                        ButtonSegment<Calendar>(
                          value: Calendar.week,
                          label: Text('Week'),
                          icon: Icon(Icons.calendar_view_week),
                        ),
                        ButtonSegment<Calendar>(
                          value: Calendar.month,
                          label: Text(
                            'Month',
                          ),
                          icon: Icon(Icons.calendar_view_month),
                        ),
                      ],
                      selected: <Calendar>{calendarView},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color(0xFF4D3C77);
                          }
                          return const Color(0xFFD67BFF);
                        }),
                      ),
                      onSelectionChanged: (Set<Calendar> newSelection) {
                        setState(() {
                          calendarView = newSelection.first;
                          if (newSelection.first == Calendar.day) {
                            period = 'daily';
                            getHarvestsByPeriod('daily');
                          } else if (newSelection.first == Calendar.week) {
                            period = 'weekly';
                            getHarvestsByPeriod('weekly');
                          } else if (newSelection.first == Calendar.month) {
                            period = 'monthly';
                            getHarvestsByPeriod('monthly');
                          }
                          formatStartDate(startDate);
                          formatEndDate(endDate);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: (screenWidth - 64) * 0.45,
                        child: TextField(
                          controller: startDateController,
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.calendar_today,
                              size: 24,
                            ),
                            labelText: 'Start Date',
                            hintText: 'Enter start date',
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          readOnly: true,
                          onTap: () => showDialog(
                            context: context,
                            builder: (BuildContext context) => PeriodDatePicker(
                              language: 'en',
                              title: 'Start Date',
                              period: period,
                              initialDate: initialDate,
                              extend: false,
                              onConfirmed: (dateTime) {
                                formatStartDate(dateTime);
                                setState(() {
                                  startDate = dateTime;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: (screenWidth - 64) * 0.45,
                        child: TextField(
                          controller: endDateController,
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.calendar_today,
                              size: 24,
                            ),
                            labelText: 'End Date',
                            hintText: 'Enter end date',
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          readOnly: true,
                          onTap: () => showDialog(
                            context: context,
                            builder: (BuildContext context) => PeriodDatePicker(
                              language: 'en',
                              title: 'End Date',
                              period: period,
                              initialDate: initialDate,
                              extend: true,
                              onConfirmed: (dateTime) {
                                formatEndDate(dateTime);
                                setState(() {
                                  endDate = dateTime;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  HarvestList(
                    period: period,
                    startDate: startDate,
                    endDate: endDate,
                    harvests: harvests,
                    loaded: loaded,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.only(top: 24),
              alignment: Alignment.center,
              child: const CircleAvatar(
                radius: 108,
                backgroundImage: AssetImage('assets/images/harvest_avatar.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double getTotalHarvestAmount(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    double totalSum = 0;
    for (var doc in docs) {
      Map<String, dynamic> data = doc.data();
      if (data.containsKey('amount') && data['amount'] is num) {
        totalSum += data['amount'];
      }
    }
    return totalSum;
  }

  void formatStartDate(DateTime dateTime) {
    if (period == 'daily') {
      String formatted = DateFormat.yMMMd().format(dateTime);
      startDateController.text = formatted;
    } else if (period == 'weekly') {
      int weekNumber = getISOWeekNumber(dateTime);
      startDateController.text = 'Week $weekNumber, ${dateTime.year} ';
    } else {
      String formattedMonth = DateFormat.yMMM().format(dateTime);
      startDateController.text = formattedMonth;
    }
  }

  void formatEndDate(DateTime dateTime) {
    if (period == 'daily') {
      String formatted = DateFormat.yMMMd().format(dateTime);
      endDateController.text = formatted;
    } else if (period == 'weekly') {
      int weekNumber = getISOWeekNumber(dateTime);
      endDateController.text = 'Week $weekNumber, ${dateTime.year} ';
    } else {
      String formattedMonth = DateFormat.yMMM().format(dateTime);
      endDateController.text = formattedMonth;
    }
  }

  int getISOWeekNumber(DateTime dateTime) {
    DateTime jan1 = DateTime(dateTime.year, 1, 1);
    int jan1Weekday = jan1.weekday;
    int daysToAdd = (jan1Weekday <= 4) ? (1 - jan1Weekday) : (8 - jan1Weekday);
    DateTime firstThursday = jan1.add(Duration(days: daysToAdd));
    int weekNumber =
        ((dateTime.difference(firstThursday).inDays) / 7).ceil() + 1;

    return weekNumber;
  }

  void getHarvestsByPeriod(String period) async {
    setState(() {
      loaded = false;
    });
    QuerySnapshot snapshot = await db
        .collection('harvests')
        .orderBy('created_at', descending: true)
        .get();
    Map<String, double> aggregatedData = {};
    if (period == 'daily') {
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime createdAt = data['created_at'].toDate();
        double amount = data['amount'].toDouble();

        String dateKey =
            "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}";

        if (aggregatedData.containsKey(dateKey)) {
          aggregatedData[dateKey] = aggregatedData[dateKey] ?? 0 + amount;
        } else {
          aggregatedData[dateKey] = amount;
        }
      }
    } else if (period == 'weekly') {
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime? createdAt = data['created_at']?.toDate();
        double? amount = data['amount']?.toDouble();

        if (createdAt != null && amount != null) {
          int weekNumber = getISOWeekNumber(createdAt);
          String weekKey = '${createdAt.year}-W$weekNumber';

          if (aggregatedData.containsKey(weekKey)) {
            aggregatedData[weekKey] = aggregatedData[weekKey] ?? 0 + amount;
          } else {
            aggregatedData[weekKey] = amount;
          }
        }
      }
    } else {
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime createdAt = data['created_at'].toDate();
        double amount = data['amount'].toDouble();

        String monthYearKey = "${createdAt.year}-${createdAt.month}";

        if (aggregatedData.containsKey(monthYearKey)) {
          aggregatedData[monthYearKey] =
              aggregatedData[monthYearKey] ?? 0 + amount;
        } else {
          aggregatedData[monthYearKey] = amount;
        }
      }
    }
    List<Map<String, dynamic>> outputList = aggregatedData.entries.map((entry) {
      return {
        'date': entry.key,
        'amount': entry.value,
      };
    }).toList();

    setState(() {
      harvests = outputList;
      loaded = true;
    });
  }
}

class HarvestTileList extends StatefulWidget {
  final String title;
  final IconData icon;
  final String firstLine;
  final String secondLine;
  const HarvestTileList({
    super.key,
    required this.title,
    required this.icon,
    required this.firstLine,
    required this.secondLine,
  });

  @override
  State<HarvestTileList> createState() => _HarvestTileListState();
}

class _HarvestTileListState extends State<HarvestTileList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width * 0.475,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Color(0xFFD67BFF),
      ),
      child: Column(
        children: [
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          ListTile(
            leading: Icon(
              widget.icon,
              color: Colors.white70,
              size: 36,
            ),
            title: Text(
              widget.firstLine,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              widget.secondLine,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
