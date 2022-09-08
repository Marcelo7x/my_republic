import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotEnvService {
  // final String path;
  late final DotEnv _env;

  _init({required path}) async {
    _env = DotEnv();
    await _env.load(fileName: path);
  }

  static Future<DotEnvService> getInstance({required String path}) async {
    final DotEnvService es = DotEnvService();
    await es._init(path: path);
    return es;
  }

  // final env = DotEnv()..load();

  operator [](String key) {
    return _env.env[key];
  }
}
