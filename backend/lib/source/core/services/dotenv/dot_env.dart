import 'package:dotenv/dotenv.dart';

class DotEnvService {
  final String path;
  late final DotEnv _env;

  DotEnvService({required this.path}) {
    _env = DotEnv()..load([path]);
  }
  // final env = DotEnv()..load();

  operator [](String key) {
    return _env[key];
  }
}
