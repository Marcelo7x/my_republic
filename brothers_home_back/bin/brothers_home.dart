import 'dart:io';
import 'package:brothers_home/backend.dart';
import 'package:shelf/shelf_io.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  final handler = await startShelfModular();

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '3001');

  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
