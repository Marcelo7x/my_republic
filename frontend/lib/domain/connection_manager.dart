import 'dart:convert';
import 'package:frontend/app/modules/auth/models/auth_models.dart';
import 'package:frontend/domain/category.dart';
import 'package:frontend/domain/enum_paid.dart';
import 'package:frontend/domain/storage_local.dart';
import 'package:uno/uno.dart';

class ConnectionManagerError implements Exception {
  final String message;
  final StackTrace? stackTrace;
  final int statusCode;

  ConnectionManagerError(this.statusCode, this.message, [this.stackTrace]);

  String toJson() {
    return jsonEncode({'error': message});
  }

  @override
  String toString() =>
      'UserException(message: $message, stackTrace: $stackTrace, statusCode: $statusCode)';
}

class ConnectionManager {
  static const _url = 'http://192.168.1.9:3001';
  static final Uno _conn = Uno();

  static Future<void> initApiClient() async {
    StorageLocal st = await StorageLocal.getInstance();
    Tokenization tokenization = Tokenization(
        accessToken: await st.getString('access_token') ?? '-',
        refreshToken: await st.getString('refresh_token') ?? '-');

    _conn.interceptors.request.use((request) async {
      request.headers['authorization'] = "Bearer " + tokenization.accessToken;
      return request;
    }, onError: (UnoError error) async {
      var origin = error.response?.request;
      if (error.response?.status == 403) {
        try {
          var data = await _conn.get("/auth/refresh_token", headers: {
            "authorization": "Bearer ${tokenization.refreshToken}"
          });

          tokenization = Tokenization.fromJson(data.data);

          await st.setString('access_token', data.data['newToken']);
          await st.setString('refresh_token', data.data['newToken']);

          origin?.headers["authorization"] =
              'Bearer ${tokenization.accessToken}';

          return _conn.request(origin!);
        } catch (err) {
          return err;
        }
      }
      return error;
    });
  }

  static Future<bool> checkToken(String token) async {
    final result = await _conn.get(
      '$_url/auth/check_token',
      headers: {"authorization": "Bearer $token"},
    );

    return (result.data['message'] ?? '') == 'ok';
  }

  static Future<Map<String, dynamic>> refreshToken(String token) async {
    final result = await _conn.get('$_url/auth/refresh_token',
        headers: {"authorization": "Bearer $token"});

    return result.data;
  }

  static Future<Map<String, dynamic>> login(
      final String email, final String password) async {
    String basicAuth = 'basic ${base64Encode(('$email:$password').codeUnits)}';

    try {
      var response = await _conn.get('$_url/auth/login', headers: {
        'authorization': basicAuth,
      });

      final data = response.data;
      if (data.length > 0 && data['access_token'] != null) {
        return data;
      }
    } on UnoError catch (e) {
      if (e.response?.status == 403) {
        throw ConnectionManagerError(e.response!.status, 'invalid credentials');
      }
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

      return result.data;
    } on Exception catch (e) {
      print(e);
      throw Exception("O servidor está desligado, tente voltar daqui a pouco");
    }
  }

  static Future number_users({required homeId}) async {
    var result = await _conn.get('$_url/home/h/users');

    return result.data;
  }

  static Future<dynamic> get_invoices(
      {required DateTime start_date,
      required DateTime end_date,
      required int home_id}) async {
    var result = await _conn.get(
        '$_url/invoice/i/start/${start_date.toIso8601String()}/end/${end_date.toIso8601String()}');

    var data = result.data;
    return data;
  }

  static Future<List<Category>> get_categories() async {
    var result = await _conn.get('$_url/home/h/category');
    var data = result.data;
    List<Category> categories = [];

    for (var e in data) {
      categories.add(Category(name: e['name'], id: e['categoryid']));
      print(e['name']);
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
      required Paid isPayed}) async {
    print('add_invoice');
    var result = await _conn.post(
      '$_url/invoice/i',
      data: jsonEncode({
        "description": description,
        "categoryid": categoryId.toString(),
        "price": price.toString(),
        "date": date.toIso8601String().toString(),
        "userid": userId.toString(),
        "homeid": homeId.toString(),
        "paid": Paid.values[isPayed.index].name
      }),
    );

    return result.data;
  }

  static Future modify_invoice(
      {required String description,
      required int categoryId,
      required int price,
      required DateTime date,
      required int userId,
      required int invoiceId,
      required Paid isPayed}) async {
    print('modify_invoice');
    var result = await _conn.put(
      '$_url/invoice/i',
      data: jsonEncode({
        "description": description,
        "categoryid": categoryId.toString(),
        "price": price.toString(),
        "date": date.toIso8601String().toString(),
        "userid": userId.toString(),
        "invoiceid": invoiceId.toString(),
        "paid": Paid.values[isPayed.index].name
      }),
    );

    return result.data;
  }

  static Future remove_invoice({
    required int invoiceid,
  }) async {
    var result = await _conn.delete('$_url/invoice/i/$invoiceid');

    return jsonDecode(result.data);
  }

  static Future subscription({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    print('subscription');
    var result = await _conn.post(
      '$_url/user/u',
      data: jsonEncode({
        "firstname": firstName,
        'lastname': lastName,
        "email": email,
        "password": password
      }),
    );

    return result;
  }

  static Future createHome({required String name}) async {
    print('subscription');
    var result = await _conn.post(
      '$_url/home/h',
      data: jsonEncode({"name": name}),
    );

    return result;
  }
}
