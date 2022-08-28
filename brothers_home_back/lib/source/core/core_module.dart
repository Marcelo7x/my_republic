import 'package:shelf_modular/shelf_modular.dart';

import 'services/database/postgres_database.dart';
import 'services/database/remote_database_interface.dart';
import 'services/dot_env.dart';
import 'services/encrypt/bcrypt_service_imp.dart';
import 'services/encrypt/encrypt_service.dart';
import 'services/jwt/dart_jsonwebtoken/jwt_service_imp.dart';
import 'services/jwt/jwt_service.dart';
import 'services/request_extractor/request_extractor.dart';

class CoreModule extends Module {
  @override
  List<Bind<Object>> get bids => [
        Bind.singleton<DotEnvService>((i) => DotEnvService(), export: true),
        Bind.singleton<RemoteDatabase>((i) => PostgresDatabase(i()),
            export: true),
        Bind.singleton<JwtService>((i) => JwtServiceImp(i()), export: true),
        Bind.singleton<EncryptService>((i) => BCryptServiceImp(), export: true),
        Bind.singleton((i) => RequestExtractor(), export: true),
      ];
}
