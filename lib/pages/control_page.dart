import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:flutter_application_1/services/appstate.dart';
import 'package:flutter_application_1/services/translations.dart';

import 'package:flutter_application_1/widgets/app_drawer.dart';
import 'package:flutter_application_1/widgets/switch_card.dart';

class ControlPage extends StatefulWidget {
  final AppState appState;
  const ControlPage({
    super.key,
    required this.appState,
  });

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool powerState = false;
  bool fanState = false;
  bool lightState = false;
  bool sprinklerState = false;
  late Image lfffsf;
  late Image lfffst;
  late Image lfftsf;
  late Image lfftst;
  late Image ltffsf;
  late Image ltffst;
  late Image ltftsf;
  late Image ltftst;

  @override
  void initState() {
    db.collection('states').doc('current').snapshots().listen((event) {
      setState(() {
        powerState = event.data()?['power'];
        fanState = event.data()?['fan'];
        lightState = event.data()?['light'];
        sprinklerState = event.data()?['sprinkler'];
      });
    });
    lfffsf =
        Image.asset('assets/images/control_bg/lf_ff_sf.png', fit: BoxFit.cover);
    lfffst =
        Image.asset('assets/images/control_bg/lf_ff_st.png', fit: BoxFit.cover);
    lfftsf =
        Image.asset('assets/images/control_bg/lf_ft_sf.png', fit: BoxFit.cover);
    lfftst =
        Image.asset('assets/images/control_bg/lf_ff_st.png', fit: BoxFit.cover);
    ltffsf =
        Image.asset('assets/images/control_bg/lt_ff_sf.png', fit: BoxFit.cover);
    ltffst =
        Image.asset('assets/images/control_bg/lt_ff_st.png', fit: BoxFit.cover);
    ltftsf =
        Image.asset('assets/images/control_bg/lt_ft_sf.png', fit: BoxFit.cover);
    ltftst =
        Image.asset('assets/images/control_bg/lt_ft_st.png', fit: BoxFit.cover);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(ltffsf.image, context);
    precacheImage(lfffst.image, context);
    precacheImage(lfftsf.image, context);
    precacheImage(lfftst.image, context);
    precacheImage(ltffsf.image, context);
    precacheImage(ltffst.image, context);
    precacheImage(ltftsf.image, context);
    precacheImage(ltftst.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(
        appState: widget.appState,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Controls',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            color: Colors.grey.shade900,
          ),
        ),
        backgroundColor: const Color(0xFFD67BFF),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            },
            splashColor: Colors.white10,
            child: Ink.image(
              fit: BoxFit.cover,
              width: 16,
              height: 16,
              image: const AssetImage('assets/images/logo.png'),
            ),
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 80,
            ),
            child: Container(
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: MediaQuery.of(context).size.height - 80,
                      child: getBackgroundImage(
                        lightState,
                        fanState,
                        sprinklerState,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SwitchCard(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.2,
                            icon: Icons.power_settings_new,
                            label: 'Power',
                            circle: true,
                            value: powerState,
                            onPressed: (value) => toggleState('power', value),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SwitchCard(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.width * 0.2,
                                icon: Icons.wind_power,
                                label: 'Fan',
                                value: fanState,
                                onPressed: (value) => toggleState('fan', value),
                              ),
                              SwitchCard(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.width * 0.2,
                                icon: Icons.light_mode,
                                label: 'Light',
                                value: lightState,
                                onPressed: (value) =>
                                    toggleState('light', value),
                              ),
                              SwitchCard(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.width * 0.2,
                                icon: Icons.shower,
                                label: 'Sprinkler',
                                value: sprinklerState,
                                onPressed: (value) =>
                                    toggleState('sprinkler', value),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void toggleState(String component, bool value) async {
    bool online = await InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 1),
    ).hasConnection;
    if (!online) {
      const internetWarning = SnackBar(
        content: Text('No internet connection!'),
      );

      ScaffoldMessenger.of(context).showSnackBar(internetWarning);
      return;
    }

    if (component == 'power') {
      setState(() {
        powerState = value;
      });
      if (!powerState) {
        setState(() {
          fanState = false;
          lightState = false;
          sprinklerState = false;
        });
      }
      db.collection('states').doc('current').update({
        'power': powerState,
        'fan': fanState,
        'light': lightState,
        'sprinkler': sprinklerState,
      });
      return;
    }

    if (!powerState) {
      const warning = SnackBar(
        content: Text('Please turn on power first!'),
      );

      ScaffoldMessenger.of(context).showSnackBar(warning);
      return;
    }

    if (component == 'fan') {
      setState(() {
        fanState = value;
      });
    } else if (component == 'light') {
      setState(() {
        lightState = value;
      });
    } else if (component == 'sprinkler') {
      setState(() {
        sprinklerState = value;
      });
    }
    db.collection('states').doc('current').update({
      'power': powerState,
      'fan': fanState,
      'light': lightState,
      'sprinkler': sprinklerState,
    });
  }

  Image getBackgroundImage(bool light, bool fan, bool sprinkler) {
    if (!light && !fan && !sprinkler) {
      return lfffsf;
    }
    if (!light && !fan && sprinkler) {
      return lfffst;
    }
    if (!light && fan && !sprinkler) {
      return lfftsf;
    }
    if (!light && fan && sprinkler) {
      return lfftst;
    }
    if (light && !fan && !sprinkler) {
      return ltffsf;
    }
    if (light && !fan && sprinkler) {
      return ltffst;
    }
    if (light && fan && !sprinkler) {
      return ltftsf;
    }
    if (light && fan && sprinkler) {
      return ltftst;
    }
    return lfffsf;
  }
}
