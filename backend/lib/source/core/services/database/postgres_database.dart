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

    // final uri = Uri.parse('postgres://postgres:postgres@postgres:5432/myrepublic');
    // final uri = Uri.parse('postgres://dsmfeihxhfgtda:3db2772d5f30229c87af9db8f16ed03d5f72c6212eab24a12d75425eddb823c6@ec2-52-3-200-138.compute-1.amazonaws.com:5432/d9o2kdm4pijg4k');

    var connection = PostgreSQLConnection(
      uri.host,
      uri.port,
      uri.pathSegments.first,
      username: uri.userInfo.split(':').first,
      password: uri.userInfo.split(':').last,
      useSSL: uri.host == 'postgres'? false:true,
    );
    await connection.open();
    completer.complete(connection);
  }

  @override
  Future<List<Map<String, Map<String, dynamic>>>> query(
    String queryText, {
    Map<String, dynamic> variables = const {},
  }) async {
    final connection = await completer.future;

    return await connection.mappedResultsQuery(
      queryText,
      substitutionValues: variables,
    );
  }

  @override
  void dispose() async {
    final connection = await completer.future;
    await connection.close();
  }
}