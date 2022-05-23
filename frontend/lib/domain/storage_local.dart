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

  Future salve_credentials(
      {required int user_id,
      required String user_name,
      required int home_id}) async {
    await _connection.setInt('user_id', user_id);
    await _connection.setInt('home_id', home_id);
    await _connection.setString('user_name', user_name);
    await _connection.setBool('is_logged', true);
  }

  Future<Map<String, dynamic>> verify_credentials() async {
    bool? logged = await _connection.getBool('is_logged');

    if (logged != null && logged) {
      int? user_id = await connection.getInt('user_id');
      int? home_id = await connection.getInt('home_id');
      String? user_name = await connection.getString('user_name');

      return {'user_id': user_id, 'home_id': home_id, 'user_name': user_name};
    } else
      return {};
  }
}
