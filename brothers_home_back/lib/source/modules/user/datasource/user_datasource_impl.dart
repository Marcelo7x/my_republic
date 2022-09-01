import 'package:brothers_home/source/core/services/database/remote_database_interface.dart';
import 'package:brothers_home/source/modules/user/repository/user_repository.dart';

class UserDatasourceImpl extends UserDatasource {
  final RemoteDatabase _database;

  UserDatasourceImpl(this._database);

  @override
  Future<void> deleteUser(int userid) async {
    await _database.query('DELETE FROM "User" WHERE userid = @userid',
        variables: {'userid': userid});
  }

  @override
  Future<List<Map<String, dynamic>?>> getAllUsers() async {
    List<Map<String, Map<String, dynamic>>> result = await _database
        .query('SELECT userid, firstname, lastname, email, role FROM "User"');

    final List<Map<String, dynamic>?> users =
        result.map((e) => e["User"]).toList();

    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> getUser(int userid) async {
    List<Map<String, Map<String, dynamic>>> result = await _database.query(
        'SELECT userid, firstname, lastname, email, role FROM "User" WHERE userid = @id',
        variables: {
          'id': userid,
        });

    final List<Map<String, dynamic>> user =
        result.map((e) => e["User"] ?? {}).toList();

    return user;
  }

  @override
  Future<dynamic> insertUser(
      String firstName, String lastName, String email, String password) async {
    var result = await _database.query(
        'INSERT INTO "User" (firstname, lastname, password,email) VALUES (@firstname, @lastname, @password, @email) RETURNING userid',
        variables: {
          'firstname': firstName,
          'lastname': lastName,
          'password': password,
          'email': email
        });
    return result;
  }

  @override
  Future<void> updateUser(Map<String, dynamic> userInfo) async {
    List columns = userInfo.entries
        .where((el) =>
            el.key != 'userid' && el.key != 'password' && el.value != null)
        .map(
          (el) => '${el.key} = @${el.key}',
        )
        .toList();

    List<Map<String, Map<String, dynamic>>> result = await _database.query(
      'UPDATE "User" SET ${columns.join(',')}  WHERE userid = @userid',
      variables: userInfo,
    );
  }
}
