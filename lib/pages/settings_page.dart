import 'package:flutter/material.dart';

import 'package:flutter_application_1/services/appstate.dart';
import 'package:flutter_application_1/widgets/app_drawer.dart';

class SettingsPage extends StatefulWidget {
  final AppState appState;
  const SettingsPage({
    super.key,
    required this.appState,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> settings = {'language': 'en', 'font_scale': 1};
  TextEditingController languageController = TextEditingController();
  SupportedLanguage? selectedLanguage;
  bool? parameterNotificationEnabled;
  bool? harvestNotificationEnabled;
  double fontScaleSliderValue = 1;

  @override
  void initState() {
    super.initState();
    fontScaleSliderValue = widget.appState.settings['font_scale'];
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuEntry<SupportedLanguage>> languageEntries =
        <DropdownMenuEntry<SupportedLanguage>>[];
    for (final SupportedLanguage language in SupportedLanguage.values) {
      languageEntries.add(
        DropdownMenuEntry<SupportedLanguage>(
          value: language,
          label: language.label,
        ),
      );
    }
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(
        appState: widget.appState,
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD67BFF),
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            color: Colors.grey.shade900,
          ),
        ),
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
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Language',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 8),
                    DropdownMenu<SupportedLanguage>(
                      // Commented as theres no other field to force rebuild widget
                      // initialSelection:
                      //     widget.appState.settings['language'] == 'en'
                      //         ? SupportedLanguage.english
                      //         : SupportedLanguage.tagalog,
                      controller: languageController,
                      enableFilter: true,
                      width: MediaQuery.of(context).size.width - 48,
                      leadingIcon: const Icon(Icons.language),
                      label: const Text('Language'),
                      dropdownMenuEntries: languageEntries,
                      textStyle: const TextStyle(
                        fontSize: 16,
                      ),
                      inputDecorationTheme: const InputDecorationTheme(
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                      ),
                      onSelected: (SupportedLanguage? language) {
                        setState(() {
                          selectedLanguage = language;
                        });
                      },
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      String languageValue = '';
                      if (languageController.text == 'Tagalog') {
                        languageValue = 'tg';
                      } else {
                        languageValue = 'en';
                      }
                      widget.appState.database.saveSettings(
                        languageValue,
                        fontScaleSliderValue,
                      );
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Settings saved'),
                          content: const Text(
                              'Settings will take effect on restart'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'OK');
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                      child: Text('Save'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum SupportedLanguage {
  english('en', 'English'),
  tagalog('tg', 'Tagalog');

  const SupportedLanguage(this.language, this.label);
  final String language;
  final String label;
}
