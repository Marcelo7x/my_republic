import 'package:shared_preferences/shared_preferences.dart';

class StorageLocal {
  late final _connection;

  StorageLocal._connect(this._connection);

  static Future<StorageLocal> getInstance() async {
    print('construido');
    var conn = await SharedPreferences.getInstance();
    var instance = StorageLocal._connect(conn);

    return instance;
  }

  get connection => _connection;

  Future setString(String key, String value) async {
    await _connection.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return await _connection.getString(key);
  }

  Future<bool> remove(String key) async {
    return await _connection.remove(key);
  }

  Future removeCredentials() async {
    await remove('access_token');
    await remove('refresh_token');
  }

  Future saveCredentials(accessToken, refreshToken) async {
    await setString('access_token', accessToken);
    await setString('refresh_token', refreshToken);
  }
}
