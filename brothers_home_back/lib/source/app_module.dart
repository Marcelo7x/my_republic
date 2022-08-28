import 'dart:convert';

import 'package:brothers_home/source/core/core_module.dart';
import 'package:brothers_home/source/modules/auth/auth_resource.dart';
import 'package:brothers_home/source/modules/home/home_resource.dart';
import 'package:brothers_home/source/modules/invoice/invoice_resource.dart';
import 'package:brothers_home/source/modules/swagger/swagger_handler.dart';
import 'package:brothers_home/source/modules/user/user_resourse.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
    CoreModule(),
  ];

  @override
  List<ModularRoute> get routes => [
        Route.get('/', _rootHandler),
        Route.get('/documentation/**', swaggerHandler),
        Route.resource(UserResource()),
        Route.resource(HomeResource()),
        Route.resource(InvoiceResource()),
        Route.resource(AuthResource()),
      ];

  Response _rootHandler() {
    Map<String, dynamic> data = {
      "current_version": "0.0.7",
      "force_update": "0.0.7",
    };

    return Response.ok(jsonEncode(data));
  }
}
