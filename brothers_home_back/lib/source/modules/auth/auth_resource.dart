import 'dart:async';
import 'dart:convert';
import 'package:brothers_home/source/modules/auth/guard/auth_guard.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../core/services/database/remote_database_interface.dart';
import '../../core/services/encrypt/encrypt_service.dart';
import '../../core/services/jwt/jwt_service.dart';
import '../../core/services/request_extractor/request_extractor.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get("/auth/login", _login),
        Route.get("/auth/refresh_token", _refreshToken,
            middlewares: [AuthGuard(isRefreshToken: true)]),
        Route.get("/auth/check_token", _checkToken, middlewares: [AuthGuard()]),
        Route.put("/auth/update_password", _updatePassword,
            middlewares: [AuthGuard()]),
      ];

  FutureOr<Response> _login(Request request, Injector injector) async {
    final extractor = injector.get<RequestExtractor>();
    final bcrypt = injector.get<EncryptService>();
    final jwt = injector.get<JwtService>();
    final database = injector.get<RemoteDatabase>();

    final credential = extractor.getAuthorizationBasic(request);

    final result = await database.query(
      'SELECT userid, role, password FROM "User" WHERE email = @email;',
      variables: {
        'email': credential.email,
      },
    );

    if (result.isEmpty) {
      return Response.forbidden(
          jsonEncode({'error': 'Email ou senha invalida'}));
    }

    final userMap = result.map((element) => element['User']).first!;

    if (!bcrypt.checkHash(credential.password, userMap['password'])) {
      return Response.forbidden(
          jsonEncode({'error': 'Email ou senha invalida'}));
    }

    final payload = userMap..remove('password');
    return Response.ok(jsonEncode(generateToken(payload, jwt)));
  }

  Map generateToken(Map payload, JwtService jwt) {
    payload['expiration'] = _expiration(Duration(minutes: 10));

    final accessToken = jwt.generateToken(payload, 'accessToken');

    payload['expiration'] = _expiration(Duration(days: 30));
    final refreshToken = jwt.generateToken(payload, 'refreshToken');
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  FutureOr<Response> _refreshToken(Request request, Injector injector) async {
    final extractor = injector.get<RequestExtractor>();
    final jwt = injector.get<JwtService>();

    final token = extractor.getAuthorizationBearer(request);
    var payload = jwt.getPayload(token);

    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
      'SELECT userid, role FROM "User" WHERE userid = @userid;',
      variables: {
        'userid': payload['userid'],
      },
    );
    payload = result.map((element) => element['User']).first!;

    return Response.ok(jsonEncode(generateToken(payload, jwt)));
  }

  FutureOr<Response> _checkToken() {
    return Response.ok(jsonEncode({'message': 'ok'}));
  }

  FutureOr<Response> _updatePassword(
    Injector injector,
    Request request,
    ModularArguments arguments,
  ) async {
    final extractor = injector.get<RequestExtractor>();
    final jwt = injector.get<JwtService>();
    final database = injector.get<RemoteDatabase>();
    final bcrypt = injector.get<EncryptService>();

    final data = arguments.data as Map;

    final token = extractor.getAuthorizationBearer(request);
    var payload = jwt.getPayload(token);

    final result = await database.query(
      'SELECT password FROM "User" WHERE userid = @userid;',
      variables: {
        'userid': payload['userid'],
      },
    );
    final password =
        result.map((element) => element['User']).first!['password'];

    if (!bcrypt.checkHash(data['password'], password)) {
      return Response.forbidden(jsonEncode({'error': 'senha invalida'}));
    }

    final queryUpdate =
        'UPDATE "User" SET password=@password WHERE userid=@userid;';
    await database.query(queryUpdate, variables: {
      'userid': payload['userid'],
      'password': bcrypt.generatHash(data['newPassword']),
    });

    return Response.ok(jsonEncode({'message': 'ok'}));
  }

  int _expiration(Duration duration) {
    final expiresDate = DateTime.now().add(duration);
    final expireIn =
        Duration(milliseconds: expiresDate.millisecondsSinceEpoch).inSeconds;

    return expireIn.toInt();
  }
}
