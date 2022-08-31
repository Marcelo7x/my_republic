import 'package:brothers_home/source/modules/home/erros/home%20_exception.dart';

abstract class HomeDatasource {
  Future<void> insertHome(Map<String, dynamic> homeParams, List columns);
  Future<void> updateHome(Map<String, dynamic> homeParams, List columns);
  Future<List<Map<String, dynamic>>> getUsersHome(int homeid);
  Future<List<Map<String, dynamic>>> getCategory();
  Future<List<Map<String, dynamic>>> getHome();
  Future<void> deleteHome(int homeid);
}

class HomeRepository {
  final HomeDatasource _datasource;

  HomeRepository(this._datasource);

  Future<void> insertHome(Map<String, dynamic> homeParams) async {
    final columns = homeParams.keys
        .map(
          (key) => '$key',
        )
        .toList();

    await _datasource.insertHome(homeParams, columns);
  }

  Future<void> updateHome(Map<String, dynamic> homeParams) async {
    if (homeParams['homeid'] == null) {
      throw HomeException(403, "Invalid homeid");
    }

    final columns = homeParams.keys
        .where((key) => key != 'homeid')
        .map(
          (key) => '$key = @$key',
        )
        .toList();

    try {
      await _datasource.updateHome(homeParams, columns);
    } catch (e) {
      throw HomeException(403, 'Erro');
    }
  }

  Future<List<Map<String, dynamic>>> getUsersHome(
      Map<String, dynamic> homeParams) async {
    if (homeParams['homeid'] == null) {
      throw HomeException(403, "Invalid homeid");
    }

    try {
      List<Map<String, dynamic>> result =
          await _datasource.getUsersHome(int.parse(homeParams['homeid']));

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

  Future<void> deleteHome(Map<String, dynamic> homeParams) async {
    if (homeParams['homeid'] == null) {
      throw HomeException(403, "Invalid homeid");
    }

    try {
      await _datasource.deleteHome(int.parse(homeParams['homeid']));
    } on Exception catch (e) {
      throw HomeException(403, 'Erro ao deletar');
    }
  }
}
