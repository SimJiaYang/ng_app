import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final SharedPreferences sharedPreferences;

  SplashRepo({required this.sharedPreferences});

  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }
}
