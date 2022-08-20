import 'dart:convert';

import 'package:brothers_home/source/modules/auth/auth_resource.dart';
import 'package:brothers_home/source/modules/home/home_resource.dart';
import 'package:brothers_home/source/modules/invoice/invoice_resource.dart';
import 'package:brothers_home/source/modules/swagger/swagger_handler.dart';
import 'package:brothers_home/source/modules/user/user_resourse.dart';
import 'package:brothers_home/source/services/database/postgres_database.dart';
import 'package:brothers_home/source/services/database/remote_database_interface.dart';
import 'package:brothers_home/source/services/dot_env.dart';
import 'package:brothers_home/source/services/encrypt/bcrypt_service_imp.dart';
import 'package:brothers_home/source/services/encrypt/encrypt_service.dart';
import 'package:brothers_home/source/services/jwt/dart_jsonwebtoken/jwt_service_imp.dart';
import 'package:brothers_home/source/services/jwt/jwt_service.dart';
import 'package:brothers_home/source/services/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.singleton<DotEnvService>((i) => DotEnvService()),
    Bind.singleton<RemoteDatabase>((i) => PostgresDatabase(i())),
    Bind.singleton<EncryptService>((i) => BCryptServiceImp()),
    Bind.singleton<JwtService>((i) => JwtServiceImp(i())),
    Bind.singleton<RequestExtractor>((i) => RequestExtractor()),
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
