import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../core/services/jwt/jwt_service.dart';
import '../../../core/services/request_extractor/request_extractor.dart';

class AuthGuard extends ModularMiddleware {
  final List<String> roles;
  final bool isRefreshToken;

  AuthGuard({this.roles = const [], this.isRefreshToken = false});

  @override
  Handler call(Handler handler, [ModularRoute? route]) {
    final RequestExtractor extractor = Modular.get<RequestExtractor>();
    final JwtService jwt = Modular.get<JwtService>();

    return (request) {
      if (!request.headers.containsKey('authorization')) {
        return Response.forbidden(
            jsonEncode({'error': 'not authorization header'}));
      }

      final token = extractor.getAuthorizationBearer(request);

      try {
        jwt.verifyToken(token, isRefreshToken ? 'refreshToken' : 'accessToken');
        final payload = jwt.getPayload(token);
        final role = payload['role'] ?? 'user';

        if (roles.isEmpty || roles.contains(role)) {
          return handler(request);
        }

        return Response.forbidden(
            jsonEncode({'error': 'role ($role) not allowed'}));
      } catch (e) {
        return Response.forbidden(jsonEncode({'error': e.toString()}));
      }
    };
  }
}
