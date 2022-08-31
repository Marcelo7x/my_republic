import 'package:brothers_home/source/core/services/encrypt/encrypt_service.dart';
import 'package:brothers_home/source/core/services/jwt/jwt_service.dart';
import 'package:brothers_home/source/modules/user/erros/userException.dart';
import 'package:brothers_home/source/modules/user/models/user_model.dart';

abstract class UserDatasource {
  Future<dynamic> insertUser(
      String firstName, String lastName, String email, String password);
  Future<List<Map<String, dynamic>?>> getAllUsers();
  Future<List<Map<String, dynamic>>> getUser(int userid);
  Future<void> updateUser(Map<String, dynamic> userInformation);
  Future<void> deleteUser(int userid);
}

class UserRepository {
  final EncryptService _bcrypt;
  final UserDatasource _datasource;
  final JwtService _jwt;

  UserRepository(this._datasource, this._bcrypt, this._jwt);

  Future insertUser(UserModel userModel) async {
    if (userModel.firstName == null ||
        userModel.lastName == null ||
        userModel.email == null ||
        userModel.password == null) {
      throw UserException(403, "Informação invalida");
    }

    final passwordHash = _bcrypt.generatHash(userModel.password!);
    var result = await _datasource.insertUser(userModel.firstName!,
        userModel.lastName!, userModel.email!, passwordHash);

    if (result.isEmpty) {
      throw UserException(403, "Informação invalida");
    }
  }

  Future<List<Map<String, dynamic>?>> getAllUsers() async {
    var result = await _datasource.getAllUsers();

    if (result.isEmpty) {
      return [];
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getUser(int userid) async {
    List<Map<String, dynamic>> result = await _datasource.getUser(userid);

    if (result == null || result.isEmpty) {
      throw UserException(403, "User not found");
    }

    return result;
  }

  Future<void> deleteUser(int userid) async {
    await _datasource.deleteUser(userid);
  }

  Future<void> updateUser(token, userParams) async {
    final payload = _jwt.getPayload(token);
    if (payload['userid'] == null) {
      throw UserException(403, "Invalid userid");
    }

    UserModel userInfo = UserModel.fromMap(userParams);
    userInfo.userid = payload['userid'];

    if (userInfo.firstName == null &&
        userInfo.lastName == null &&
        userInfo.email == null &&
        userInfo.password == null) {
      throw UserException(403, "Invalid parameters");
    }

    await _datasource.updateUser(userInfo.userInformaitionToMap());
  }
}
