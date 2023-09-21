import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class ParameterHistory  extends StatefulWidget {
  final double width;
  final double x;
  final double y;

  final List<dynamic> humidity_1;
  final List<dynamic> light_1;
  final List<dynamic>soil_1;
  final List<dynamic> temperature_1;
  final double title;
  
  const ParameterHistory({
    required this.width,
    required this.x,
    required this.y,
    required this.humidity_1,
    required this.light_1,
    required this.soil_1,
    required this.temperature_1,
    required this.title,});

  @override
  State<ParameterHistory> createState() => _ParameterHistoryState();
}

class _ParameterHistoryState extends State<ParameterHistory> {
  @override
 

  Widget build(BuildContext context) {
     final humidity_1 = widget.humidity_1;
     final soil_1 = widget.soil_1;
     final light_1 =widget.light_1;
     final temperature_1=widget.temperature_1;
     
    return Container(
      width: widget.width,
      height: 150,
       decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFD5A4EC)),
      padding: const EdgeInsets.all(8),
      child: const Column(
        
      )
    );
  }
}