import 'dart:convert';
import 'package:dio/dio.dart';

class ConnectionManager {
  static final _url = 'http://192.168.1.9:8080/';
  static final Dio _conn = Dio();

  static Future<Map<String, dynamic>> login(
      final String email, final String password) async {
    try {
      var response = await _conn.post(_url + 'login',
          data: jsonEncode([
            {"email": email.replaceAll(RegExp(r' '), ''), "password": password}
          ]));

      final data = jsonDecode(response.data);
      if (data.length > 0 && data[0]['users']['userid'] != null) {
        return data[0];
      } else {}
    } catch (e) {
      print(e);
    }
    return {};
  }

  static Future<Map<String, dynamic>?> verify_server() async {
    Map<String, dynamic>? data;

    try {
      var result = await _conn.get(_url).timeout(Duration(seconds: 7), onTimeout: () {
        throw Exception();
      });

      data = jsonDecode(result.data);
    } on Exception catch (e) {
      throw Exception("O servidor está desligado, tente voltar daqui a pouco");
    }

    return data;
  }
}
