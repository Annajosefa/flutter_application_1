import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_1/widgets/linechart.dart';

enum Parameter {
  humidity('humidity', 'Humidity History'),
  light('light', 'Light Level History'),
  soil('soil', 'Soil Moisture History'),
  temperature('temperature', 'Temperature History');

  const Parameter(this.value, this.label);
  final String value;
  final String label;
}

class ParameterHistoryPage extends StatefulWidget {
  const ParameterHistoryPage({super.key});

  @override
  State<ParameterHistoryPage> createState() => _ParameterHistoryPageState();
}

class _ParameterHistoryPageState extends State<ParameterHistoryPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Parameter selectedParameter = Parameter.temperature;
  List<dynamic> humidityList = [];
  List<dynamic> lightList = [];
  List<dynamic> soilList = [];
  List<dynamic> temperatureList = [];
  int totalProcessed = 0;
  String lastUpdatedDate = '';
  String lastUpdatedTime = '';

  @override
  void initState() {
    super.initState();
    db.collection('parameters').snapshots().listen((event) {
      setState(() {
        humidityList = modifyParameterList(event, 'humidity', 30);
        lightList = modifyParameterList(event, 'light', 30);
        soilList = modifyParameterList(event, 'soil', 30);
        temperatureList = modifyParameterList(event, 'temperature', 30);
        totalProcessed = event.docs.length;
        lastUpdatedDate = DateFormat.yMMMMd()
            .format(event.docs.last.data()['created_at'].toDate());
        lastUpdatedTime = DateFormat.jms()
            .format(event.docs.last.data()['created_at'].toDate());
      });
      FlutterLogs.logInfo('Parameter History Page', 'Firebase',
          'Got ${event.docs.length} data!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFD67BFF),
        title: const Text(
          'Parameter History',
          style: TextStyle(
            fontFamily: 'Roboto Condensed',
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.8),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    selectedParameter.label,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: ConditionalParameterLineChart(
                    parameter: selectedParameter,
                    humidityList: humidityList,
                    lightList: lightList,
                    soilList: soilList,
                    temperatureList: temperatureList,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  alignment: Alignment.center,
                  child: SegmentedButton<Parameter>(
                    segments: const <ButtonSegment<Parameter>>[
                      ButtonSegment<Parameter>(
                        value: Parameter.temperature,
                        icon: Icon(Icons.thermostat),
                      ),
                      ButtonSegment<Parameter>(
                        value: Parameter.humidity,
                        icon: Icon(Icons.water_drop),
                      ),
                      ButtonSegment<Parameter>(
                        value: Parameter.soil,
                        icon: Icon(Icons.stream),
                      ),
                      ButtonSegment<Parameter>(
                        value: Parameter.light,
                        icon: Icon(Icons.light_mode),
                      ),
                    ],
                    selected: <Parameter>{selectedParameter},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Color.fromARGB(255, 167, 68, 212);
                        }
                        return const Color(0xFFD67BFF);
                      }),
                      iconColor: MaterialStateColor.resolveWith(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.white70;
                        }
                        return Colors.grey.shade800;
                      }),
                    ),
                    onSelectionChanged: (Set<Parameter> newSelection) {
                      setState(() {
                        selectedParameter = newSelection.first;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 167, 68, 212),
                        Color(0xFFD67BFF),
                      ],
                      begin: Alignment(-1.0, -4.0),
                      end: Alignment(1.0, 2.0),
                    ),
                    border: Border.all(
                      color: Colors.grey.shade800,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(48),
                      topRight: Radius.circular(48),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 1,
                        right: 1,
                        child: Image.asset(
                          'assets/images/home_bg.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 24,
                        left: 12,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                            color: Colors.white60,
                          ),
                          child: ListTile(
                            isThreeLine: true,
                            leading: const Icon(
                              Icons.av_timer,
                              color: Color(0xFFD67BFF),
                              size: 48,
                            ),
                            title: const Text('Last Updated'),
                            subtitle: Text(
                              '$lastUpdatedTime\n$lastUpdatedDate',
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 128,
                        left: 12,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                            color: Colors.white60,
                          ),
                          child: ListTile(
                            isThreeLine: true,
                            leading: const Icon(
                              Icons.satellite_alt,
                              color: Color(0xFFD67BFF),
                              size: 48,
                            ),
                            title: const Text('Data Processed'),
                            subtitle: Text(
                              '$totalProcessed Data sent from machine',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<dynamic> modifyParameterList(
    QuerySnapshot<Map<String, dynamic>> event,
    String parameter,
    int max,
  ) {
    List<dynamic> parameterList = [];
    if (event.docs.length > 30) {
      event.docs.getRange(0, 30).forEach((element) {
        parameterList.add(element.data()[parameter].toDouble());
      });
    } else {
      for (var element in event.docs) {
        parameterList.add(element.data()[parameter].toDouble());
      }
    }
    return parameterList;
  }
}

class ConditionalParameterLineChart extends StatefulWidget {
  final Parameter parameter;
  final List<dynamic> humidityList;
  final List<dynamic> lightList;
  final List<dynamic> soilList;
  final List<dynamic> temperatureList;
  const ConditionalParameterLineChart({
    super.key,
    required this.parameter,
    required this.humidityList,
    required this.lightList,
    required this.soilList,
    required this.temperatureList,
  });

  @override
  State<ConditionalParameterLineChart> createState() =>
      _ConditionalParameterLineChartState();
}

class _ConditionalParameterLineChartState
    extends State<ConditionalParameterLineChart> {
  @override
  Widget build(BuildContext context) {
    if (widget.parameter == Parameter.humidity) {
      return ParameterLineChart(
        values: widget.humidityList,
        interval: 20,
        borderColor: const Color.fromARGB(255, 167, 68, 212),
        fillColor: const Color(0xFFD67BFF),
      );
    } else if (widget.parameter == Parameter.temperature) {
      return ParameterLineChart(
        values: widget.temperatureList,
        interval: 20,
        borderColor: const Color.fromARGB(255, 167, 68, 212),
        fillColor: const Color(0xFFD67BFF),
      );
    } else if (widget.parameter == Parameter.soil) {
      return ParameterLineChart(
        values: widget.soilList,
        interval: 20,
        borderColor: const Color.fromARGB(255, 167, 68, 212),
        fillColor: const Color(0xFFD67BFF),
      );
    } else {
      return ParameterLineChart(
        values: widget.lightList,
        interval: 1000,
        borderColor: const Color.fromARGB(255, 167, 68, 212),
        fillColor: const Color(0xFFD67BFF),
      );
    }
  }
}
