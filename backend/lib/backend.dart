import 'package:brothers_home/source/app_module.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

Future<Handler> startShelfModular({required String dotEnvPath}) async {
  final handler = Modular(module: AppModule(dotEnvPath: dotEnvPath), middlewares: [
    logRequests(),
    jsonResponse(),
  ]);

  return handler;
}

Middleware jsonResponse() {
  return (handler) {
    return (request) async {
      var response = await handler(request);

      response = response.change(headers: {
        'content-type': 'application/json',
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET,PUT,PATCH,POST,DELETE",
        "Access-Control-Allow-Headers": "Origin, X-Requested-With, Content-Type, Accept",
        ...response.headers,
      });

      return response;
    };
  };
}
