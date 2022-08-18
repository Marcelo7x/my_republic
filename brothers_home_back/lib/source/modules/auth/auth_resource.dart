import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get("/auth/login", _login),
        Route.get("/auth/refresh-token", _login),
        Route.get("/auth/check_token", _login),
        Route.post("/auth/update_password", _login),
      ];

  FutureOr<Response> _login() {
    return Response.ok('');
  }  
  FutureOr<Response> _refreshToken() {
    return Response.ok('');
  } 
  FutureOr<Response> _checkToken() {
    return Response.ok('');
  }  
  FutureOr<Response> _updatePassword() {
    return Response.ok('');
  }
}
