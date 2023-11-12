import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/database.dart';

class AppState extends ChangeNotifier {
  late OnionSenseDatabase database;
  Map<String, dynamic> settings = {
    'language': 'en',
    'font_scale': 1,
  };

  void initializeDatabase(OnionSenseDatabase initializedDatabase) {
    database = initializedDatabase;
  }

  void initializeSettings(Map<String, dynamic> initializedSettings) {
    settings = initializedSettings;
  }
}
