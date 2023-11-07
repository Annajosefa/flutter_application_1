import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class PeriodDatePicker extends StatefulWidget {
  final String language;
  final String title;
  final String period;
  final DateTime initialDate;
  final Function(DateTime) onConfirmed;
  final bool extend;
  const PeriodDatePicker(
      {super.key,
      required this.language,
      required this.title,
      required this.period,
      required this.initialDate,
      required this.onConfirmed,
      required this.extend});

  @override
  State<PeriodDatePicker> createState() => _PeriodDatePickerState();
}

class _PeriodDatePickerState extends State<PeriodDatePicker> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    _selectedDate = widget.initialDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.period == 'daily') {
      return AlertDialog(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (widget.extend) {
                widget.onConfirmed(
                  _selectedDate.add(
                    const Duration(hours: 23, minutes: 59, seconds: 59),
                  ),
                );
              } else {
                widget.onConfirmed(_selectedDate);
              }
              Navigator.pop(context);
            },
            child: const Text(
              'Ok',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
        content: DayPicker.single(
          selectedDate: _selectedDate,
          onChanged: _onSelectedDateChanged,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          datePickerStyles: dayPickerStyles,
          datePickerLayoutSettings: const DatePickerLayoutSettings(
            showPrevMonthEnd: true,
            showNextMonthStart: true,
          ),
        ),
      );
    } else if (widget.period == 'weekly') {
      return AlertDialog(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (widget.extend) {
                widget.onConfirmed(
                  _selectedDate.add(
                    const Duration(hours: 23, minutes: 59, seconds: 59),
                  ),
                );
              } else {
                widget.onConfirmed(_selectedDate);
              }
              Navigator.pop(context);
            },
            child: const Text(
              'Ok',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
        content: WeekPicker(
          selectedDate: _selectedDate,
          onChanged: _onSelectedWeekChanged,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          datePickerStyles: weekPickerStyle,
          datePickerLayoutSettings: const DatePickerLayoutSettings(
            showPrevMonthEnd: true,
            showNextMonthStart: true,
          ),
        ),
      );
    } else {
      return AlertDialog(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (widget.extend) {
                widget.onConfirmed(
                  _selectedDate.add(
                    const Duration(hours: 23, minutes: 59, seconds: 59),
                  ),
                );
              } else {
                widget.onConfirmed(_selectedDate);
              }
              Navigator.pop(context);
            },
            child: const Text(
              'Ok',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
        content: MonthPicker.single(
          selectedDate: _selectedDate,
          onChanged: _onSelectedMonthChanged,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          datePickerStyles: monthPickerStyle,
          datePickerLayoutSettings: const DatePickerLayoutSettings(
            showPrevMonthEnd: true,
            showNextMonthStart: true,
          ),
        ),
      );
    }
  }

  DatePickerRangeStyles dayPickerStyles = DatePickerRangeStyles(
    selectedSingleDateDecoration: const BoxDecoration(
      color: Color(0xFFDECB65),
      shape: BoxShape.circle,
    ),
  );

  DatePickerRangeStyles weekPickerStyle = DatePickerRangeStyles(
    selectedPeriodLastDecoration: BoxDecoration(
        color: Colors.red.shade400,
        borderRadius: const BorderRadiusDirectional.only(
            topEnd: Radius.circular(10.0), bottomEnd: Radius.circular(10.0))),
    selectedPeriodStartDecoration: BoxDecoration(
      color: Colors.blue.shade400,
      borderRadius: const BorderRadiusDirectional.only(
          topStart: Radius.circular(10.0), bottomStart: Radius.circular(10.0)),
    ),
    selectedPeriodMiddleDecoration: const BoxDecoration(
        color: Color(0xFFDECB65), shape: BoxShape.rectangle),
  );

  DatePickerRangeStyles monthPickerStyle = DatePickerRangeStyles(
    selectedSingleDateDecoration: const BoxDecoration(
      color: Color(0xFFDECB65),
      shape: BoxShape.circle,
    ),
  );

  void _onSelectedDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  void _onSelectedWeekChanged(DatePeriod newPeriod) {
    setState(() {
      if (widget.extend) {
        _selectedDate = newPeriod.end;
      } else {
        _selectedDate = newPeriod.start;
      }
    });
  }

  void _onSelectedMonthChanged(DateTime newDate) {
    setState(() {
      if (widget.extend) {
        DateTime lastDayOfMonth = DateTime(newDate.year, newDate.month + 1, 0);
        _selectedDate = lastDayOfMonth;
      } else {
        _selectedDate = newDate;
      }
    });
  }
}
