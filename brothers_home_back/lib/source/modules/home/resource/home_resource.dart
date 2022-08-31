import 'dart:async';
import 'dart:convert';
import 'package:brothers_home/source/modules/auth/guard/auth_guard.dart';
import 'package:brothers_home/source/modules/home/erros/home%20_exception.dart';
import 'package:brothers_home/source/modules/home/repository/home_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class HomeResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/h', _getHome, middlewares: [
          AuthGuard(roles: ['admin'])
        ]),
        Route.post('/h', _insertHome, middlewares: [AuthGuard()]),
        Route.delete('/h/:homeid', _deleteHome, middlewares: [AuthGuard()]),
        Route.put('/h', _updateHome, middlewares: [AuthGuard()]),
        Route.get('/h/:homeid/users', _getUsersHome, middlewares: [AuthGuard()]),
        Route.get('/category', _getCategory, middlewares: [AuthGuard()]),
      ];

  FutureOr<Response> _insertHome(
      ModularArguments arguments, Injector injector) async {
    final homeParams = (arguments.data).cast<String, dynamic>();

    final homeRepository = injector.get<HomeRepository>();

    try {
      await homeRepository.insertHome(homeParams);
    } on HomeException catch (e) {
      return Response(e.statusCode, body: e.message);
    }

    return Response.ok(jsonEncode({"menssage": "Ok"}));
  }

  FutureOr<Response> _getHome(Injector injector) async {
    final homeRepository = injector.get<HomeRepository>();

    try {
      List<Map<String, dynamic>> result = await homeRepository.getHome();
      if (result == null) {
        throw HomeException(403, "Error");
      }

      return Response.ok(jsonEncode(result));
    } on HomeException catch (e) {
      return Response(e.statusCode, body: e.message);
    }
  }

  FutureOr<Response> _getUsersHome(
      ModularArguments arguments, Injector injector) async {
    var homeParams = (arguments.params).cast<String, dynamic>();

    final homeRepository = injector.get<HomeRepository>();

    try {
      List<Map<String, dynamic>> result =
          await homeRepository.getUsersHome(homeParams);

      return Response.ok(jsonEncode(result));
    } on HomeException catch (e) {
      return Response(e.statusCode, body: e.message);
    }
  }

  FutureOr<Response> _updateHome(
      ModularArguments arguments, Injector injector) async {
    final homeParams = (arguments.data).cast<String, dynamic>();
    final homeRepository = injector.get<HomeRepository>();

    try {
      await homeRepository.updateHome(homeParams);
    } on HomeException catch (e) {
      return Response(e.statusCode, body: e.message);
    }

    return Response.ok(jsonEncode({"menssage": "Ok"}));
  }

  FutureOr<Response> _deleteHome(
      ModularArguments arguments, Injector injector) async {
    final homeParams = (arguments.params).cast<String, dynamic>();

    final homeRepository = injector.get<HomeRepository>();

    try {
      await homeRepository.deleteHome(homeParams);
    } on HomeException catch (e) {
      return Response(e.statusCode, body: e.message);
    }

    return Response.ok(jsonEncode({"menssage": "Ok"}));
  }

  FutureOr<Response> _getCategory(
      ModularArguments arguments, Injector injector) async {
    final homeParams = (arguments.data).cast<String, dynamic>();

    final homeRepository = injector.get<HomeRepository>();

    try {
      List<Map<String, dynamic>> result = await homeRepository.getCategory();
    
      return Response.ok(jsonEncode(result));
    } on HomeException catch (e) {
      return Response(e.statusCode, body: e.message);
    }
  }
}
