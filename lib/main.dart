import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_1/widget/parameter_card.dart';
import 'package:flutter_application_1/widget/harvest_row.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/services/notification_service.dart';
import 'package:flutter_application_1/widget/linechart.dart';

late var fcmKey;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(message.notification?.body ?? 'No new notification');
    showNotification(message.notification?.title ?? 'No title',
        message.notification?.body ?? 'No body');
    // showNotification(message.notification?.body ?? 'No new notification');
  });
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  fcmKey = await FirebaseMessaging.instance.getToken();

  runApp(const MyApp());
}

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  showNotification(message.notification?.title ?? 'No title',
      message.notification?.body ?? 'No body');
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
          body: const Home(
            humidity_1: [],
            light_1: [],
            soil_1: [],
            temperature_1: [],
          )),
    );
  }
}

class Home extends StatefulWidget {
  final List<dynamic> humidity_1;
  final List<dynamic> light_1;
  final List<dynamic> soil_1;
  final List<dynamic> temperature_1;

  const Home({
    Key? key,
    required this.humidity_1,
    required this.light_1,
    required this.soil_1,
    required this.temperature_1,
  }) : super(key: key);

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
  List<dynamic> humidity_1 = [];
  List<dynamic> light_1 = [];
  List<dynamic> soil_1 = [];
  List<dynamic> temperature_1 = [];

  @override
  void initState() {
    final parameterRef =
        db.collection('parameters').snapshots().listen((event) {
      setState(() {
        humidity = event.docs.last.data()['humidity'].toDouble();
        light = event.docs.last.data()['light'].toDoule();
        soil = event.docs.last.data()['soil'].toDouble();
        temperature = event.docs.last.data()['temperature'].toDouble();

        humidity_1 = [];
        if (event.docs.length > 30) {
          event.docs.getRange(0, 30).forEach((element) {
            humidity_1.add(element.data()['humidity'].toDouble());
          });
        } else {
          event.docs.forEach((element) {
            humidity_1.add(element.data()['humidity'].toDouble());
          });
        }
        print(humidity_1);

        light_1 = [];
        if (event.docs.length > 30) {
          event.docs.getRange(0, 30).forEach((element) {
            light_1.add(element.data()['light'].toDouble());
          });
        } else {
          event.docs.forEach((element) {
            light_1.add(element.data()['light'].toDouble());
          });
        }
        print(light_1);

        soil_1 = [];
        if (event.docs.length > 30) {
          event.docs.getRange(0, 30).forEach((element) {
            soil_1.add(element.data()['soil'].toDouble());
          });
        } else {
          event.docs.forEach((element) {
            soil_1.add(element.data()['soil'].toDouble());
          });
        }
        print(soil_1);

        temperature_1 = [];
        if (event.docs.length > 30) {
          event.docs.getRange(0, 30).forEach((element) {
            temperature_1.add(element.data()['temperature'].toDouble());
          });
        } else {
          event.docs.forEach((element) {
            temperature_1.add(element.data()['temperature'].toDouble());
          });
        }
        print(temperature_1);
      });
      print(event.docs.last.data());
      onError: (error) => print("listen failed: $error ");
    });

    final harvestref = db.collection('harvests').orderBy('created_at').snapshots().listen((event) {
      setState(() {
        harvests = [];
        event.docs.reversed.forEach((element) {
          harvests.add(element.data());
        });
      });
      print(harvests);
      onError: (error) => print("listen failed: $error ");
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
      onError: (error) => print("listen failed: $error ");
    });

    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
        width: (MediaQuery.of(context).size.width),
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFA3175A), Color(0x00A3175A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 1500,
            ),
            child: Column(
              children: [
                const SizedBox(
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
                const SizedBox(
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
                const SizedBox(height: 15),
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
                      const SizedBox(
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
                                                  .9) *
                                              .6,
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
                                                  .9) *
                                              .2,
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
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: (MediaQuery.of(context).size.width - 16) *  .9,
                  height: 250,
                  decoration: ShapeDecoration(color: const Color.fromARGB(255, 220, 182, 238),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: ((MediaQuery.of(context).size.width - 16) *  .9) *  .9,
                        height: 40,
                        padding: const EdgeInsets.all(5),
                        decoration: ShapeDecoration(
                          color: const Color((0xfcb205cf)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)
                        )
                      ),
                      child: const Row (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('HUMIDITY',style: TextStyle(color: Colors.black, 
                          fontFamily: ' Roboto', 
                          fontSize: 15, 
                          fontWeight: FontWeight.w700,
                          height: 1.10,
                          letterSpacing: 0.45), 
                          )
                        ],
                      ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ParameterLineChart(values: humidity_1, interval: 20, color: Color.fromARGB(255, 170, 23, 104)),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),

              ],
            ),
          ),
        ));
  }
}
