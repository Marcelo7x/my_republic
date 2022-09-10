import 'package:brothers_home/source/core/services/database/remote_database_interface.dart';
import 'package:brothers_home/source/modules/home/repository/home_repository.dart';

class HomeDatasourceImpl extends HomeDatasource {
  final RemoteDatabase _database;

  HomeDatasourceImpl(RemoteDatabase this._database);

  @override
  Future<void> deleteHome(int homeid) async {
    await _database.query(
      'DELETE FROM "Home" WHERE homeid = @homeid',
      variables: {'homeid': homeid},
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getUsersHome(int homeid) async {
    List<Map<String, Map<String, dynamic>>>? result = await _database.query(
      'SELECT u.userid, u.firstname, u.lastname FROM "User" u INNER JOIN "Home" h ON u.homeid = h.homeid WHERE h.homeid = @homeid',
      variables: {'homeid': homeid},
    );

    final List<Map<String, dynamic>> homes =
        result.map((e) => e["User"] ?? {}).toList();

    return homes;
  }

  @override
  Future<List<Map<String, dynamic>>> getHome() async {
    List<Map<String, Map<String, dynamic>>> result =
        await _database.query('SELECT * FROM "Home"');

    final List<Map<String, dynamic>> homes =
        result.map((e) => e["Home"] ?? {}).toList();

    return homes;
  }

  @override
  Future<Map<String, dynamic>> insertHome(
      Map<String, dynamic> homeParams, List columns) async {
    await _database.query(
      'INSERT INTO "Home" (homeid,${columns.join(',')}) VALUES (DEFAULT, @${columns.join(',@')})',
      variables: homeParams,
    );

    return getHomeByName(homeParams['name']);
  }

  @override
  Future<void> updateHome(Map<String, dynamic> homeParams, List columns) async {
    await _database.query(
      'UPDATE "Home" SET ${columns.join(',')}  WHERE homeid = @homeid',
      variables: homeParams,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getCategory() async {
    List<Map<String, Map<String, dynamic>>> result =
        await _database.query('SELECT * FROM "Category"');

    final List<Map<String, dynamic>> categories =
        result.map((e) => e["Category"] ?? {}).toList();

    return categories;
  }

  @override
  Future<Map<String, dynamic>> getHomeByName(String homename) async {
    List<Map<String, Map<String, dynamic>>> result = await _database.query(
      'SELECT homeid FROM "Home" WHERE name = @homename',
      variables: {'homename': homename},
    );

    final List<Map<String, dynamic>> home =
        result.map((e) => e["Home"] ?? {}).toList();

    return home.length > 0 ? home.first : {};
  }

  @override
  Future<void> entryRequest(int userid, int homeid) async {
    await _database.query(
      'INSERT INTO "EntryRequest" (entryrequestid, userid, homeid) VALUES (DEFAULT, @userid, @homeid)',
      variables: {
        'userid' : userid,
        'homeid' : homeid,
      },
    );
  }

  @override
  Future<Map<String, dynamic>> getEntryRequest(int userid) async {
    List<Map<String, Map<String, dynamic>>> result = await _database.query(
      'SELECT userid FROM "EntryRequest" WHERE userid = @userid',
      variables: {
        'userid' : userid,
      },
    );

    return result.map((e) => e["EntryRequest"] ?? {}).first;
  }
}
