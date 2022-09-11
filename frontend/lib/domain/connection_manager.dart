import 'dart:convert';
import 'package:frontend/app/modules/auth/models/auth_models.dart';
import 'package:frontend/domain/category.dart';
import 'package:frontend/domain/dotenv/dot_env.dart';
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
  late Uno _conn;

  _init(String DotEnvPath) async {
    final env = await DotEnvService.getInstance(path: DotEnvPath);
    _conn = Uno(baseURL: env['API_URL']);
  }

  static Future<ConnectionManager> getInstance(
      {required String dotEnvPath}) async {
    ConnectionManager c = ConnectionManager();
    await c._init(dotEnvPath);
    await c.initApiClient();
    return c;
  }

  Future<void> initApiClient() async {
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

  removeInterceptors() async {
    // final myInterceptor = _conn.interceptors.request.use((request) => request);
    // _conn.interceptors.request.eject(myInterceptor);

    _conn = Uno(baseURL: _conn.baseURL);
  }

  Future<bool> checkToken(String token) async {
    removeInterceptors();
    try {
      final result = await _conn.get(
        'auth/check_token',
        headers: {"authorization": "Bearer $token"},
      );

      await initApiClient();

      return (result.data['message'] ?? '') == 'ok';
    } on UnoError catch (e) {
      if (e.response?.status == 403) {
        throw ConnectionManagerError(e.response!.status, 'invalid credentials');
      }
    }

    await initApiClient();
    return false;
  }

  Future<Map<String, dynamic>> refreshToken(String token) async {
    removeInterceptors();

    try {
      final result = await _conn.get('auth/refresh_token',
          headers: {"authorization": "Bearer $token"});
      await initApiClient();
      return result.data;
    } on UnoError catch (e) {
      throw ConnectionManagerError(403, 'invalid token');
    }
  }

  Future<Map<String, dynamic>> login(
      final String email, final String password) async {
    String basicAuth = 'basic ${base64Encode(('$email:$password').codeUnits)}';

    removeInterceptors();
    try {
      var response = await _conn.get('auth/login', headers: {
        'authorization': basicAuth,
      });

      final data = response.data;
      await initApiClient();

      if (data.length > 0 && data['access_token'] != null) {
        return data;
      }
    } on UnoError catch (e) {
      if (e.response?.status == 403) {
        await initApiClient();

        throw ConnectionManagerError(e.response!.status, 'invalid credentials');
      }
    }
    await initApiClient();
    return {};
  }

  Future<Map<String, dynamic>?> verify_server() async {
    Map<String, dynamic>? data;

    try {
      var result = await _conn.get('').timeout(const Duration(seconds: 7),
          onTimeout: () {
        throw Exception();
      });

      return result.data;
    } on Exception catch (e) {
      print(e);
      throw Exception("O servidor está desligado, tente voltar daqui a pouco");
    }
  }

  Future number_users({required homeId}) async {
    var result = await _conn.get('home/h/users');

    return result.data;
  }

  Future<dynamic> get_invoices(
      {required DateTime start_date,
      required DateTime end_date,
      required int home_id}) async {
    var result = await _conn.get(
        'invoice/i/start/${start_date.toIso8601String()}/end/${end_date.toIso8601String()}');

    var data = result.data;
    return data;
  }

  Future<List<Category>> get_categories() async {
    var result = await _conn.get('home/h/category');
    var data = result.data;
    List<Category> categories = [];

    for (var e in data) {
      categories.add(Category(name: e['name'], id: e['categoryid']));
      print(e['name']);
    }

    return categories;
  }

  Future add_invoice(
      {required String description,
      required int categoryId,
      required int price,
      required DateTime date,
      required int userId,
      required int homeId,
      required Paid isPayed}) async {
    print('add_invoice');
    var result = await _conn.post(
      'invoice/i',
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

  Future modify_invoice(
      {required String description,
      required int categoryId,
      required int price,
      required DateTime date,
      required int userId,
      required int invoiceId,
      required Paid isPayed}) async {
    print('modify_invoice');
    var result = await _conn.put(
      'invoice/i',
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

  Future remove_invoice({
    required int invoiceid,
  }) async {
    var result = await _conn.delete('invoice/i/$invoiceid');

    return result.data;
  }

  Future userRegistration({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    var result = await _conn.post(
      'user/u',
      data: jsonEncode({
        "firstname": firstName,
        'lastname': lastName,
        "email": email,
        "password": password
      }),
    );

    return result;
  }

  Future userUpadate({
    String? firstName,
    String? lastName,
    String? email,
    int? homeid,
  }) async {
    Map<String, dynamic> info = {};

    if (firstName != null) info['firstName'] = firstName;
    if (lastName != null) info['lastName'] = lastName;
    if (email != null) info['email'] = email;
    if (homeid != null) info['homeid'] = homeid;

    if (info.isNotEmpty) {
      try {
        var result = await _conn.put(
          'user/u',
          data: jsonEncode(info),
        );
      } on UnoError catch (e) {
        if (e.response?.status == 403) {
          throw ConnectionManagerError(e.response!.status, 'error userUpadate');
        }
      }
    }
  }

  Future homeRegistration({
    required String homename,
    String? street,
    String? district,
    String? city,
    String? state,
    String? country,
    int? number,
    int? cep,
  }) async {
    Map<String, dynamic> info = {};
    info['name'] = homename;

    if (street != null) info['street'] = street;
    if (district != null) info['street'] = street;
    if (city != null) info['street'] = street;
    if (state != null) info['street'] = street;
    if (country != null) info['street'] = street;
    if (number != null) info['street'] = street;
    if (cep != null) info['street'] = street;

    try {
      var result = await _conn.post(
        'home/h',
        data: jsonEncode(info),
      );
      return result.data;
    } on UnoError catch (e) {
      if (e.response?.status == 403) {
        throw ConnectionManagerError(
            e.response!.status, 'error create home by name');
      }
    }
  }

  Future<Map> homeSearch(String homename) async {
    print('home search');
    try {
      var result = await _conn.get('home/h/homename/$homename');
      return result.data;
    } on UnoError catch (e) {
      if (e.response?.status == 403 || e.response == null) {
        throw ConnectionManagerError(
            e.response?.status ?? 403, 'erro search home by name');
      }
    }
    return {};
  }

  Future<void> entryRequest(int homeid) async {
    try {
      await _conn.post('home/h/entry_request/$homeid');
    } on UnoError catch (e) {
      if (e.response?.status == 403 || e.response == null) {
        throw ConnectionManagerError(
            e.response?.status ?? 403, 'erro entryRequest');
      }
    }
  }

  Future<bool> getEntryRequest() async {
    try {
      final result = await _conn.get('home/h/entry_request');
      final data = result.data;

      if (data['exist_request'] == null || data['exist_request'] != 'yes') {
        return false;
      }

      return true;
    } on UnoError catch (e) {
      if (e.response?.status == 403 || e.response == null) {
        throw ConnectionManagerError(
            e.response?.status ?? 403, 'erro getEntryRequest');
      }
    }
    return false;
  }

  Future<List> verifyEntryRequest() async {
    try {
      final result = await _conn.get('home/h/entry_request/home');
      final data = result.data;

      if (data == null || data.isEmpty) {
        return [];
      }

      return data;
    } on UnoError catch (e) {
      if (e.response?.status == 403 || e.response == null) {
        throw ConnectionManagerError(
            e.response?.status ?? 403, 'erro verifyEntryRequest');
      }
    }
    return [];
  }

  Future<void> acceptEntryRequest(int userid) async {
    try {
      await _conn.put('home/h/entry_request/$userid');
      
    } on UnoError catch (e) {
      if (e.response?.status == 403 || e.response == null) {
        throw ConnectionManagerError(
            e.response?.status ?? 403, 'erro acceptEntryRequest');
      }
    }
  }

  Future<void> deleteEntryRequest(int userid) async {
    try {
      await _conn.delete('home/h/entry_request/$userid');
      
    } on UnoError catch (e) {
      if (e.response?.status == 403 || e.response == null) {
        throw ConnectionManagerError(
            e.response?.status ?? 403, 'erro acceptEntryRequest');
      }
    }

  }
}
