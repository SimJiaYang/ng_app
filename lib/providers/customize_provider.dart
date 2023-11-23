import 'package:flutter/foundation.dart';
import 'package:nurserygardenapp/data/repositories/customize_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomizeProvider extends ChangeNotifier {
  final CustomizeRepo customizeRepo;
  final SharedPreferences sharedPreferences;

  CustomizeProvider(
      {required this.customizeRepo, required this.sharedPreferences});
}
