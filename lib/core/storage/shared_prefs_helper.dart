import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static final SharedPrefsHelper _instance = SharedPrefsHelper._internal();                                            //to save them in the same memory

  late SharedPreferences _prefs;

  SharedPrefsHelper._internal();

  factory SharedPrefsHelper() => _instance;

  Future<void> init() async{
    _prefs = await SharedPreferences.getInstance();
  }
  String? getName() {
    return _prefs.getString('name');
  }
  Future<void> saveUserName(String name) {
    return _prefs.setString('name', name);
  }

  String? getString(String key){
    return _prefs.getString(key);
  }
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<void> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }



  Future<void> clear() =>
      _prefs.clear();
}