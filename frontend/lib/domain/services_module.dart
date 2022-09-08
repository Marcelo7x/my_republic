import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/domain/connection_manager.dart';
import 'package:frontend/domain/dotenv/dot_env.dart';
import 'package:frontend/domain/jwt/jwt_decode_impl.dart';
import 'package:frontend/domain/jwt/jwt_decode_service.dart';

class ServicesModule extends Module {
  final String dotEnvPath;
  ServicesModule({required this.dotEnvPath});

  @override
  List<Bind> get binds => [
        AsyncBind<DotEnvService>(
            (i) => DotEnvService.getInstance(path: dotEnvPath),
            export: true),
        Bind.singleton<JwtDecodeService>((i) => JwtDecodeServiceImpl(),
            export: true),
        AsyncBind<ConnectionManager>((i) => ConnectionManager.getInstance(dotEnvPath: dotEnvPath),
            export: true),
      ];
}
