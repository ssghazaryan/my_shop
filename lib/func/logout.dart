import 'package:shared_preferences/shared_preferences.dart';

void logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
}
