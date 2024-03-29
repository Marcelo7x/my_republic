import 'package:brothers_home/source/core/services/database/postgres_database.dart';
import 'package:brothers_home/source/core/services/database/remote_database_interface.dart';
import 'package:brothers_home/source/core/services/dotenv/dot_env.dart';
import 'package:brothers_home/source/core/services/encrypt/bcrypt_service_imp.dart';
import 'package:brothers_home/source/core/services/encrypt/encrypt_service.dart';
import 'package:brothers_home/source/core/services/jwt/dart_jsonwebtoken/jwt_service_imp.dart';
import 'package:brothers_home/source/core/services/jwt/jwt_service.dart';
import 'package:brothers_home/source/core/services/request_extractor/request_extractor.dart';
import 'package:shelf_modular/shelf_modular.dart';

class CoreModule extends Module {
  final String dotEnvPath;
  CoreModule({required this.dotEnvPath});

  @override
  List<Bind> get binds => [
        Bind.singleton<DotEnvService>((i) => DotEnvService(path: dotEnvPath),
            export: true),
        Bind.singleton<RemoteDatabase>((i) => PostgresDatabase(i()),
            export: true),
        Bind.singleton<JwtService>((i) => JwtServiceImp(i()), export: true),
        Bind.singleton<EncryptService>((i) => BCryptServiceImp(), export: true),
        Bind.singleton((i) => RequestExtractor(), export: true),
      ];
}
