import 'package:dotenv/dotenv.dart';

class DotEnvService {
  final env = DotEnv()..load();

  operator [](String key) {
    return env[key];
  }
}
