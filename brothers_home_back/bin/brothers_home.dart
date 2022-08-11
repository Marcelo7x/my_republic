import 'dart:io';
import 'dart:convert';

import 'package:brothers_home/DB.dart';
import 'package:brothers_home/source/app/app_module.dart';
import 'package:brothers_home/source/backend.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_modular/shelf_modular.dart';

void main(List<String> args) async {
  //connection BD
  print("connectando BD...");
  var db = DB.instance;
  await db.database;

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  final handler = await startShelfModular();

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '3001');

  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
