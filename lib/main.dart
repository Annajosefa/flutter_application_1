
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_1/widget/parameter_card.dart';
import 'package:flutter_application_1/widget/harvest_row.dart';

import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Onion Sense'),
            backgroundColor: Color(0xFFA3175A),
            leading: Image.asset('assets/images/logo.png'),
          ),
          body: const Home()),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
  List<dynamic> humidity_1= humidity_1[];
  List<dynamic> light_1 = light_1[];
  List<dynamic> soil_1= soil_1[];
  List<dynamic> temperature_1= temperature_1[];

  @override
  void initState() {
    final parameterRef =
        db.collection('parameters').snapshots().listen((event) {
      setState(() {
        humidity = event.docs.last.data()['humidity'];
        light = event.docs.last.data()['light'];
        soil = event.docs.last.data()['soil'];
        temperature = event.docs.last.data()['temperature'];
      });
      print(event.docs.last.data());
    });
    final harvestref = db.collection('harvests').snapshots().listen((event) {
      setState(() {
        harvests = [];
        event.docs.reversed.forEach((element) {
          harvests.add(element.data());
        });
      });
      print(harvests);
    });
    final rowsRef = db.collection('rows').snapshots().listen((event) {
      setState(() {
        r1 = event.docs.last.data()['r1'];
        r2 = event.docs.last.data()['r2'];
        r3 = event.docs.last.data()['r3'];
        r4 = event.docs.last.data()['r4'];
        r5 = event.docs.last.data()['r5'];
      });
      print(event.docs.last.data());
    });
    humidity_1 = [];
    if(event.docs.length > 30) {
      event.docs.getRange(0,30).forEach((element){
        humidity_1.add(element.data()['humidity_1']);
      });
    }
    else {
      event.docs.forEach((element){
        humidity_1.add(element.data()['humidity_1']);
      });
    }
    print(humidity_1);
    super.initState();
  }
  @override

  @override
  Widget build(BuildContext context) {
    return Container(
        width: (MediaQuery.of(context).size.width),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFA3175A), Color(0x00A3175A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 1500,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ParameterCard(
                      width: (MediaQuery.of(context).size.width - 16) * 0.4,
                      title: 'Humidity (%)',
                      icon: Icon(
                        Icons.water_drop_sharp,
                        color: Colors.blue.shade500,
                      ),
                      value: humidity,
                      decimal: 1,
                    ),
                    ParameterCard(
                      width: (MediaQuery.of(context).size.width - 16) * 0.4,
                      title: 'Light Level (lux)',
                      icon: Icon(
                        Icons.light_mode_sharp,
                        color: Colors.yellow.shade500,
                      ),
                      value: light,
                      decimal: 0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ParameterCard(
                      width: (MediaQuery.of(context).size.width - 16) * 0.4,
                      title: 'Soil Moisture(%)',
                      icon: Icon(
                        Icons.grain_sharp,
                        color: Colors.brown.shade500,
                      ),
                      value: soil,
                      decimal: 1,
                    ),
                    ParameterCard(
                      width: (MediaQuery.of(context).size.width - 16) * 0.4,
                      title: 'Temperature(°C)',
                      icon: Icon(
                        Icons.thermostat_sharp,
                        color: Colors.blue.shade500,
                      ),
                      value: temperature,
                      decimal: 1,
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  width: (MediaQuery.of(context).size.width - 16) * .9,
                  height: 290,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 199, 110, 240)),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      HarvestRow(
                        width: ((MediaQuery.of(context).size.width - 16) * .9) -
                            32,
                        title: 'Row 1',
                        value: r1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      HarvestRow(
                        width: ((MediaQuery.of(context).size.width - 16) * .9) -
                            32,
                        title: 'Row 2',
                        value: r2,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      HarvestRow(
                        width: ((MediaQuery.of(context).size.width - 16) * .9) -
                            32,
                        title: 'Row 3',
                        value: r3,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      HarvestRow(
                        width: ((MediaQuery.of(context).size.width - 16) * .9) -
                            32,
                        title: 'Row 4',
                        value: r4,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      HarvestRow(
                        width: ((MediaQuery.of(context).size.width - 16) * .9) -
                            32,
                        title: 'Row 5',
                        value: r5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: (MediaQuery.of(context).size.width - 16) * .9,
                  height: 450,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 199, 110, 240)),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Harvest',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 30,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          width:
                              ((MediaQuery.of(context).size.width - 16) * .9) *
                                  .9,
                          height: 380,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 220, 182, 238),
                          ),
                          child: ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemCount: harvests.length,
                            itemBuilder: (BuildContext context, int index) {
                              DateTime dateTime =
                                harvests[index]['created_at'].toDate();
                              String dateString =
                                  DateFormat('MMMM d, y').format(dateTime);
                              return Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 199, 110, 240),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width:
                                          (((MediaQuery.of(context).size.width -
                                                          16) *
                                                      .9) *
                                                  .9) *  .6,
                                      child: Text(
                                        dateString,
                                        style: const TextStyle(
                                            fontFamily: 'Roboto', fontSize: 15),
                                      ),
                                    ),
                                    Container(
                                      width:
                                          (((MediaQuery.of(context).size.width -
                                                          16) *
                                                      .9) *
                                                  .9) * .2,
                                      height: 65,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color.fromARGB(
                                              255, 238, 196, 232)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            harvests[index]['amount']
                                                .toStringAsFixed(1),
                                            style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
