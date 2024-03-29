import 'package:brothers_home/source/core/services/jwt/jwt_service.dart';
import 'package:brothers_home/source/modules/home/erros/home%20_exception.dart';

abstract class HomeDatasource {
  Future<Map<String, dynamic>> insertHome(
      Map<String, dynamic> homeParams, List columns);
  Future<void> updateHome(Map<String, dynamic> homeParams, List columns);
  Future<List<Map<String, dynamic>>> getUsersHome(int homeid);
  Future<List<Map<String, dynamic>>> getCategory();
  Future<List<Map<String, dynamic>>> getHome();
  Future<Map<String, dynamic>> getHomeByName(String homename);
  Future<Map<String, dynamic>> getEntryRequestByUserid(int userid);
  Future<List<Map<String, dynamic>>> getEntryRequestByHomeid(int homeid);
  Future<void> acceptEntryRequest(int userid, int homeid);
  Future<void> deleteEntryRequest(int userid, int homeid);
  Future<void> entryRequest(int userid, int homeid);
  Future<void> deleteHome(int homeid);
}

class HomeRepository {
  final HomeDatasource _datasource;
  final JwtService _jwt;

  HomeRepository(this._datasource, this._jwt);

  Future<Map<String, dynamic>> insertHome(
      Map<String, dynamic> homeParams) async {
    if (homeParams['name'] == null) {
      throw HomeException(403, 'nao contem o name');
    }

    if (homeParams['name'].toString().split(' ').length > 1) {
      throw HomeException(403, 'o nome deve conter apenas uma palavra');
    }

    final columns = homeParams.keys
        .map(
          (key) => '$key',
        )
        .toList();

    Map<String, dynamic> result =
        await _datasource.insertHome(homeParams, columns);
    return result;
  }

  Future<void> updateHome(token, Map<String, dynamic> homeParams) async {
    final payload = _jwt.getPayload(token);

    if (payload['homeid'] == null) {
      throw HomeException(403, "Invalid homeid");
    }

    final columns = homeParams.keys
        .where((key) => key != 'homeid')
        .map(
          (key) => '$key = @$key',
        )
        .toList();

    homeParams['homeid'] = payload['homeid'];

    try {
      await _datasource.updateHome(homeParams, columns);
    } catch (e) {
      throw HomeException(403, 'Erro');
    }
  }

  Future<List<Map<String, dynamic>>> getUsersHome(token) async {
    final payload = _jwt.getPayload(token);

    if (payload['homeid'] == null) {
      throw HomeException(403, "Invalid homeid");
    }

    try {
      List<Map<String, dynamic>> result =
          await _datasource.getUsersHome(payload['homeid']);

      if (result == null) {
        throw HomeException(403, "Error");
      }

      return result;
    } on HomeException catch (e) {
      throw HomeException(e.statusCode, e.message);
    }
  }

  Future<List<Map<String, dynamic>>> getHome() async {
    try {
      List<Map<String, dynamic>> result = await _datasource.getHome();

      if (result == null) {
        throw HomeException(403, "Error");
      }

      return result;
    } on HomeException catch (e) {
      throw HomeException(e.statusCode, e.message);
    }
  }

  Future<List<Map<String, dynamic>>> getCategory() async {
    try {
      List<Map<String, dynamic>> result = await _datasource.getCategory();

      if (result == null) {
        throw HomeException(403, "Error Category");
      }

      return result;
    } on HomeException catch (e) {
      throw HomeException(e.statusCode, e.message);
    }
  }

  Future<void> deleteHome(token) async {
    final payload = _jwt.getPayload(token);

    if (payload['homeid'] == null) {
      throw HomeException(403, "Invalid homeid");
    }

    try {
      await _datasource.deleteHome(payload['homeid']);
    } on Exception catch (e) {
      throw HomeException(403, 'Erro ao deletar');
    }
  }

  Future<Map<String, dynamic>> getHomeByName(homeParams) async {
    try {
      Map<String, dynamic> result =
          await _datasource.getHomeByName(homeParams['name']);

      if (result == null || result.isEmpty) {
        throw HomeException(403, "Error Searching Home");
      }

      return result;
    } on HomeException catch (e) {
      throw HomeException(e.statusCode, e.message);
    }
  }

  Future<void> entryRequest(homeParams, token) async {
    final payload = _jwt.getPayload(token);

    if (payload['userid'] == null) {
      throw HomeException(403, "Invalid userid");
    }

    if (payload['homeid'] != null) {
      throw HomeException(403, "Has exist homeid");
    }

    try {
      await _datasource.entryRequest(
          payload['userid'], int.parse(homeParams['homeid']));
    } on HomeException catch (e) {
      throw HomeException(e.statusCode, e.message);
    }
  }

  Future<bool> getEntryRequestByUserid(token) async {
    final payload = _jwt.getPayload(token);

    if (payload['userid'] == null) {
      throw HomeException(403, "Invalid userid");
    }

    if (payload['homeid'] != null) {
      throw HomeException(403, "Has exist homeid");
    }

    try {
      Map<String, dynamic> result =
          await _datasource.getEntryRequestByUserid(payload['userid']);

      if (result.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on HomeException catch (e) {
      throw HomeException(e.statusCode, e.message);
    }
  }

  Future<List<Map<String, dynamic>>> getEntryRequestByHomeid(token) async {
    final payload = _jwt.getPayload(token);

    if (payload['userid'] == null) {
      throw HomeException(403, "Invalid userid");
    }

    if (payload['homeid'] == null) {
      throw HomeException(403, "Invalid Homeid");
    }

    try {
      List<Map<String, dynamic>> result =
          await _datasource.getEntryRequestByHomeid(payload['homeid']);

      return result;
    } on HomeException catch (e) {
      throw HomeException(e.statusCode, e.message);
    }
  }

  Future<void> acceptEntryRequest(homeParams, token) async {
    final payload = _jwt.getPayload(token);

    if (homeParams['userid'] == null) {
      throw HomeException(403, "Invalid userid");
    }

    if (payload['homeid'] == null) {
      throw HomeException(403, "Invalid homeid");
    }

    try {
      await _datasource.acceptEntryRequest(
          int.parse(homeParams['userid']), payload['homeid']);

      await deleteEntryRequest(homeParams, token);
    } on HomeException catch (e) {
      throw HomeException(e.statusCode, e.message);
    }
  }

  Future<void> deleteEntryRequest(homeParams, token) async {
    final payload = _jwt.getPayload(token);

    if (homeParams['userid'] == null) {
      throw HomeException(403, "Invalid userid");
    }

    if (payload['homeid'] == null) {
      throw HomeException(403, "Invalid homeid");
    }

    try {
      await _datasource.deleteEntryRequest(
          int.parse(homeParams['userid']), payload['homeid']);
    } on HomeException catch (e) {
      throw HomeException(e.statusCode, e.message);
    }
  }
}
