import 'dart:async';
import 'dart:convert';
import 'package:brothers_home/source/core/services/request_extractor/request_extractor.dart';
import 'package:brothers_home/source/modules/auth/guard/auth_guard.dart';
import 'package:brothers_home/source/modules/user/erros/userException.dart';
import 'package:brothers_home/source/modules/user/models/user_model.dart';
import 'package:brothers_home/source/modules/user/repository/user_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../core/services/encrypt/bcrypt_service_imp.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/u', _getAllUsers, middlewares: [
          AuthGuard(roles: ['admin'])
        ]),
        Route.get('/u/:userid', _getUser, middlewares: [
          AuthGuard(roles: ['admin'])
        ]),
        Route.post('/u', _insertUser),
        Route.put('/u', _updateUser, middlewares: [
          AuthGuard(roles: ['admin'])
        ]),
        Route.delete('/u/:userid', _deleteUser, middlewares: [
          AuthGuard(roles: ['admin'])
        ]),
      ];

  FutureOr<Response> _insertUser(
      ModularArguments arguments, Injector injector) async {
    final bcrypt = injector.get<BCryptServiceImp>();
    final userParams = (arguments.data as Map).cast<String, dynamic>();
    final userRepository = injector.get<UserRepository>();

    UserModel userInfo = UserModel(
        firstName: userParams['firstname'],
        lastName: userParams['lastname'],
        email: userParams['email'],
        password: userParams['password']);
    try {
      await userRepository.insertUser(userInfo);
      return Response.ok(jsonEncode({"message": "Sucessfully inserted"}));
    } on UserException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _getAllUsers(Injector injector) async {
    final userRepository = injector.get<UserRepository>();
    try {
      final result = await userRepository.getAllUsers();
      return Response.ok(jsonEncode(result));
    } on UserException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _getUser(
      Injector injector, ModularArguments arguments) async {
    var userRepository = injector.get<UserRepository>();
    var params = arguments.params;

    try {
      List<Map<String, dynamic>> result =
          await userRepository.getUser(int.parse(params['userid']));
      return Response.ok(jsonEncode(result));
    } on UserException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _updateUser(Request request,
      Injector injector, ModularArguments arguments) async {
    final userRepository = injector.get<UserRepository>();
    final extractor = injector.get<RequestExtractor>();

    final token = extractor.getAuthorizationBearer(request);
    final userParams = (arguments.data as Map).cast<String, dynamic>();

    try {
      await userRepository.updateUser(token, userParams);
      return Response.ok(jsonEncode(jsonEncode({'message':'Updated user'})));
    } on UserException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _deleteUser(
      ModularArguments arguments, Injector injector) async {
    final userRepository = injector.get<UserRepository>();
    var userParams = arguments.params;

    try {
      await userRepository.deleteUser(int.parse(userParams['userid']));

      return Response.ok(
          jsonEncode(<String, String>{'message': 'Usuário removido'}));
    } on UserException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }
}
