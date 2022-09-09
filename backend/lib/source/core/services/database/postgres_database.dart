import 'dart:async';
import 'package:postgres/postgres.dart';
import 'package:shelf_modular/shelf_modular.dart';
import '../dotenv/dot_env.dart';
import 'remote_database_interface.dart';

class PostgresDatabase implements RemoteDatabase, Disposable {
  final completer = Completer<PostgreSQLConnection>();
  final DotEnvService dotEnv;

  PostgresDatabase(this.dotEnv) {
    _init();
  }

  _init() async {
    final url = dotEnv['DATABASE_URL']!;

    final uri = Uri.parse(url);

    var connection = PostgreSQLConnection(
      uri.host,
      uri.port,
      uri.pathSegments.first,
      username: uri.userInfo.split(':').first,
      password: uri.userInfo.split(':').last,
      useSSL: uri.host == 'postgres' ? false : true,
    );
    await connection.open();
    completer.complete(connection);
  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> query(
    String queryText, {
    Map<String, dynamic> variables = const {},
  }) async {
    bool erroConnection = false;
    do {
      final connection = await completer.future;

      try {
        return await connection.mappedResultsQuery(
          queryText,
          substitutionValues: variables,
        );
      } on PostgreSQLException catch (e) {
        if (!erroConnection) {
          erroConnection = true;
          _init();
          continue;
        } else {
          rethrow;
        }
      }
    } while (erroConnection);
  }

  @override
  void dispose() async {
    final connection = await completer.future;
    await connection.close();
  }
}
