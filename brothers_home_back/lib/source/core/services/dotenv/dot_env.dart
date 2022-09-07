import 'package:dotenv/dotenv.dart';

class DotEnvService {
  // final env = DotEnv()..load();
  final env = DotEnv()..load(['.envDev']);

  operator [](String key) {
    return env[key];
  }
}
