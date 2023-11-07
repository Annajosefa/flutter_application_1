import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isoweek/isoweek.dart';

class HarvestList extends StatefulWidget {
  final String period;
  final DateTime startDate;
  final DateTime endDate;
  final List<Map<String, dynamic>> harvests;
  final bool loaded;
  const HarvestList({
    super.key,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.loaded,
    required this.harvests,
  });

  @override
  State<HarvestList> createState() => _HarvestListState();
}

class _HarvestListState extends State<HarvestList> {
  @override
  Widget build(BuildContext context) {
    if (!widget.loaded) {
      return const CircularProgressIndicator(color: Color(0xFFD67BFF));
    }
    List<dynamic> filteredHarvests = [];
    for (Map<String, dynamic> harvest in widget.harvests) {
      if (widget.period == 'daily') {
        DateTime dateTime =
            DateTime.parse(harvest['date']).add(const Duration(hours: 8));
        if (dateTime.isAfter(widget.startDate) &&
            dateTime.isBefore(widget.endDate.add(const Duration(hours: 8)))) {
          filteredHarvests.add(harvest);
        }
      } else if (widget.period == 'weekly') {
        Week week = Week.fromISOString(harvest['date']);
        DateTime firstWeekDay = week.day(0);
        DateTime lastWeekDay = week.day(6);
        if (lastWeekDay.isAfter(widget.startDate) &&
            firstWeekDay.isBefore(widget.endDate)) {
          filteredHarvests.add(harvest);
        }
      } else if (widget.period == 'monthly') {
        DateTime firstMonthDay =
            DateTime(widget.startDate.year, widget.startDate.month);
        DateTime lastMonthDay =
            DateTime(widget.endDate.year, widget.endDate.month, 30);
        DateTime dateTime = DateTime.parse(harvest['date'] + '-02');
        if (dateTime.isAfter(firstMonthDay) &&
            dateTime.isBefore(lastMonthDay)) {
          filteredHarvests.add(harvest);
        }
      }
    }
    if (filteredHarvests.isEmpty) {
      return const Center(
        child: Text(
          'No harvests falls in the given date ranges',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }
    return Container(
      alignment: Alignment.center,
      height: 350,
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          String dateString = '';
          if (widget.period == 'daily') {
            DateTime date = DateTime.parse(filteredHarvests[index]['date']);
            dateString = DateFormat.yMMMMd().format(date);
          } else if (widget.period == 'weekly') {
            String tempDateString = filteredHarvests[index]['date'].toString();
            dateString =
                'Week ${tempDateString.substring(6)}, ${tempDateString.substring(0, 4)}';
          } else {
            List<String> months = [
              'January',
              'February',
              'March',
              'April',
              'May',
              'June',
              'July',
              'August',
              'September',
              'October',
              'November',
              'December'
            ];
            String tempDateString = filteredHarvests[index]['date'].toString();
            dateString =
                '${months[int.parse(tempDateString.split('-')[1]) - 1]} ${tempDateString.split('-')[0]}';
          }
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(32, 4, 48, 4),
              leading: const Icon(
                Icons.clean_hands_rounded,
                fill: 1,
                color: Color(0xFF4D3C77),
                size: 36,
              ),
              title: Text('Harvest No.${index + 1}'),
              subtitle: Text(dateString),
              trailing: Text(
                  '${filteredHarvests[index]['amount'].toStringAsFixed(1)} kg',
                  style: const TextStyle(
                    fontFamily: 'Roboto Condensed',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: filteredHarvests.length,
      ),
    );
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
}
