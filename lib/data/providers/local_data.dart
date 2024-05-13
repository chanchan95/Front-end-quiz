import 'package:ptit_quiz_frontend/core/constants/data_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalData {
  Future<void> saveToken(String token);
  Future<void> deleteToken();
  String getToken();

  Future<void> saveRefreshToken(String token);
  Future<void> deleteRefreshToken();
  String getRefreshToken();
}

class LocalDataImpl implements LocalData {
  final SharedPreferences sharedPreferences;

  LocalDataImpl({required this.sharedPreferences});

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(DataKey.token, token);
  }

  @override
  Future<void> deleteToken() async {
    await sharedPreferences.remove(DataKey.token);
  }

  @override
  String getToken() {
    return sharedPreferences.getString(DataKey.token) ?? '';
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await sharedPreferences.setString(DataKey.refreshToken, token);
  }

  @override
  Future<void> deleteRefreshToken() async {
    await sharedPreferences.remove(DataKey.refreshToken);
  }

  @override
  String getRefreshToken() {
    return sharedPreferences.getString(DataKey.refreshToken) ?? '';
  }
}