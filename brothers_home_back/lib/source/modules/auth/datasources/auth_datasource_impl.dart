import '../../../core/services/database/remote_database_interface.dart';
import '../repositories/auth_repository.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final RemoteDatabase database;

  AuthDatasourceImpl(this.database);

  @override
  Future<Map> getCredentialsByEmail(String email) async {
    final result = await database.query(
      'SELECT userid, homeid, role, password FROM "User" WHERE email = @email;',
      variables: {
        'email': email,
      },
    );

    if (result.isEmpty) {
      return {};
    }

    return result.map((element) => element['User']).first!;
  }

  @override
  Future<Map<String, dynamic>> getRoleAndHoemidByUserid(userid) async {
    final result = await database.query(
      'SELECT role, homeid FROM "User" WHERE userid = @userid;',
      variables: {
        'userid': userid,
      },
    );

    return result.map((element) => element['User']).first!;
  }

  @override
  Future<String> getPasswordById(userid) async {
    final result = await database.query(
      'SELECT password FROM "User" WHERE userid = @userid;',
      variables: {
        'userid': userid,
      },
    );
    return result.map((element) => element['User']).first!['password'];
  }

  @override
  Future<void> updatePasswordById(userid, String password) async {
    final queryUpdate =
        'UPDATE "User" SET password=@password WHERE userid = @userid;';

    await database.query(queryUpdate, variables: {
      'userid': userid,
      'password': password,
    });
  }
}
