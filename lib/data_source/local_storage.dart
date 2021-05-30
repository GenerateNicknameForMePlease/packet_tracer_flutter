import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageApi {
  static const String _tokenKey = 'token';

  static LocalStorageApi _instance;

  static LocalStorageApi get instance => _instance;

  SharedPreferences _sharedPreferences;

  LocalStorageApi._internal();

  factory LocalStorageApi() {
    if (_instance == null) {
      _instance = LocalStorageApi._internal();
    }
    return _instance;
  }

  Future<void> init() async {
    if (_instance == null) {
      _instance = LocalStorageApi._internal();
    }
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  String get getToken => _sharedPreferences.getString(_tokenKey);

  void setToken(String s) => _sharedPreferences.setString(_tokenKey, s);

  void logout() {
    _sharedPreferences.remove(_tokenKey);
  }
}
