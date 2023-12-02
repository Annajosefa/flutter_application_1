import 'package:flutter/material.dart';

import 'package:flutter_application_1/services/appstate.dart';
import 'package:flutter_application_1/services/translations.dart';

import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/settings_page.dart';
import 'package:flutter_application_1/pages/about_page.dart';

class AppDrawer extends StatefulWidget {
  final AppState appState;
  const AppDrawer({
    super.key,
    required this.appState,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drawer Header
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/onion.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(32, 32),
                  bottomRight: Radius.elliptical(32, 32),
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                bottom: 24,
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/harvest_avatar.png'),
                    minRadius: 90,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'OnionSense',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            /// Header Menu items
            Column(
              children: [
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.home_outlined,
                        size: 36,
                      ),
                      title: Text(
                        translations['home']
                            [widget.appState.settings['language']],
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => HomePage(
                                  appState: widget.appState,
                                )),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.settings,
                        size: 32,
                      ),
                      title: Text(
                        translations['settings']
                            [widget.appState.settings['language']],
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: ((context) =>
                                SettingsPage(appState: widget.appState)),
                          ),
                        );
                      },
                    ),
                    const Divider(color: Colors.black45),
                    ListTile(
                      leading: const Icon(
                        Icons.info,
                        size: 32,
                      ),
                      title: Text(
                        translations['about']
                            [widget.appState.settings['language']],
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => AboutPage(
                                  appState: widget.appState,
                                )),
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
