import 'package:flutter/material.dart';

import 'package:flutter_application_1/services/appstate.dart';

import 'package:flutter_application_1/widgets/app_drawer.dart';

class AboutPage extends StatefulWidget {
  final AppState appState;
  const AboutPage({
    super.key,
    required this.appState,
  });

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(appState: widget.appState),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Onion Sense',
          style: TextStyle(
            fontFamily: 'Roboto Condensed',
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFFD67BFF),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            }, // Image tapped
            splashColor: Colors.white10, // Splash color over image
            child: Ink.image(
              fit: BoxFit.cover, // Fixes border issues
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
              minHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            child: Column(
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
