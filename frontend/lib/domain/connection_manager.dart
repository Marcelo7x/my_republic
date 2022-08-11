import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:frontend/domain/category.dart';

class ConnectionManager {
  static const _url = 'http://192.168.1.9:3001/';
  static final Dio _conn = Dio();

  static Future<Map<String, dynamic>> login(
      final String email, final String password) async {
    try {
      var response = await _conn.post('${_url}login',
          data: jsonEncode(
            {"email": email.replaceAll(RegExp(r' '), ''), "password": password}
          ));

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

  static Future number_users({required homeId}) async {
    var result = await _conn.post(
        '${_url}number-users',
        data: jsonEncode(
          {
            "homeId": homeId.toString(),
          }
        ),
      );

    return jsonDecode(result.data);
  }

  static Future<dynamic> get_invoices(
      {required DateTime start_date,
      required DateTime end_date,
      required int home_id}) async {
    var result = await _conn.post(
      '${_url}list-invoices-date-interval',
      data: jsonEncode(
        {
          'first_date': start_date.toIso8601String().toString(),
          'last_date': end_date.toIso8601String().toString(),
          'homeid': home_id,
        }
      ),
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

  static Future add_invoice(
      {required String description,
      required int categoryId,
      required int price,
      required DateTime date,
      required int userId,
      required int homeId,
      required bool? isPayed}) async {
    print('add_invoice');
    var result = await _conn.post(
      '${_url}add-invoice',
      data: jsonEncode(
        {
          "description": description,
          "categoryId": categoryId.toString(),
          "price": price.toString(),
          "date": date.toIso8601String().toString(),
          "userId": userId.toString(),
          "homeId": homeId.toString(),
          "paid": isPayed
        }
      ),
    );

    return jsonDecode(result.data);
  }

  static Future modify_invoice(
      {required String description,
      required int categoryId,
      required int price,
      required DateTime date,
      required int userId,
      required int invoiceId,
      required bool? isPayed}) async {
    print('modify_invoice');
    var result = await _conn.put(
      '${_url}modify-invoice',
      data: jsonEncode(
        {
          "description": description,
          "categoryId": categoryId.toString(),
          "price": price.toString(),
          "date": date.toIso8601String().toString(),
          "userId": userId.toString(),
          "invoiceId": invoiceId.toString(),
          "paid": isPayed
        }
      ),
    );

    return jsonDecode(result.data);
  }

  static Future remove_invoice({
    required int userId,
    required int invoiceId,
  }) async {
    var result = await _conn.delete(
      '${_url}remove-invoice',
      data: jsonEncode(
        {
          "userId": userId.toString(),
          "invoiceId": invoiceId.toString(),
        }
      ),
    );

    return jsonDecode(result.data);
  }
}
