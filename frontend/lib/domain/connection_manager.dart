import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/domain/category.dart';

class ConnectionManager {
  static const _url = 'http://192.168.1.9:8080/';
  static final Dio _conn = Dio();

  static Future<Map<String, dynamic>> login(
      final String email, final String password) async {
    try {
      var response = await _conn.post('${_url}login',
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
      var result = await _conn.get(_url).timeout(const Duration(seconds: 7),
          onTimeout: () {
        throw Exception();
      });

      data = jsonDecode(result.data);
    } on Exception catch (e) {
      throw Exception("O servidor está desligado, tente voltar daqui a pouco");
    }

    return data;
  }

  static Future<dynamic> get_invoices(
      {required DateTime start_date,
      required DateTime end_date,
      required int home_id}) async {
    var result = await _conn.post(
      '${_url}list-invoices-date-interval',
      data: jsonEncode([
        {
          'first_date': start_date.toIso8601String().toString(),
          'last_date': end_date.toIso8601String().toString(),
          'homeid': home_id,
        }
      ]),
    );

    var data = jsonDecode(result.data);

    return data;
  }

  static Future<List<Category>> get_categories() async {
    var result = await _conn.get('${_url}list-categories');
    var data = jsonDecode(result.data);
    List<Category> categories = [];

    for (var e in data) {
      categories.add(Category(
          name: e['category']['name'], id: e['category']['categoryId']));
      print(e['category']['name']);
    }

    return categories;
  }
}
