import '../../../core/services/encrypt/encrypt_service.dart';
import '../../../core/services/jwt/jwt_service.dart';
import '../../../core/services/request_extractor/request_extractor.dart';
import '../errors/errors.dart';
import '../models/tokenization.dart';

abstract class AuthDatasource {
  Future<Map> getIdAndRoleByEmail(String email);
  Future<String> getRoleById(id);
  Future<String> getPasswordById(id);
  Future<void> updatePasswordById(id, String password);
}

class AuthRepository {
  final EncryptService bcrypt;
  final JwtService jwt;
  final AuthDatasource datasource;

  AuthRepository(this.datasource, this.bcrypt, this.jwt);

  Future<Tokenization> login(LoginCredential credential) async {
    final userMap = await datasource.getIdAndRoleByEmail(credential.email);

    if (userMap.isEmpty) {
      throw AuthException(403, 'Email ou senha invalida');
    }

    if (!bcrypt.checkHash(credential.password, userMap['password'])) {
      throw AuthException(403, 'Email ou senha invalida');
    }

    final payload = userMap..remove('password');

    return _generateToken(payload);
  }

  Future<Tokenization> refreshToken(String token) async {
    final payload = jwt.getPayload(token);
    final role = await datasource.getRoleById(payload['userid']);
    return _generateToken({
      'userid': payload['userid'],
      ' role': role,
    });
  }

  Tokenization _generateToken(Map payload) {
    payload['exp'] = _determineExpiration(Duration(days: 3));

    final accessToken = jwt.generateToken(payload, 'accessToken');

    payload['exp'] = _determineExpiration(Duration(days: 7));
    final refreshToken = jwt.generateToken(payload, 'refreshToken');
    return Tokenization(accessToken: accessToken, refreshToken: refreshToken);
  }

  int _determineExpiration(Duration duration) {
    final expiresDate = DateTime.now().add(duration);
    final expiresIn = Duration(milliseconds: expiresDate.millisecondsSinceEpoch);
    return expiresIn.inSeconds;
  }

  Future<void> updatePassword(String token, String password, String newPassword) async {
    final payload = jwt.getPayload(token);
    final hash = await datasource.getPasswordById(payload['userid']);

    if (!bcrypt.checkHash(password, hash)) {
      throw AuthException(403, 'senha invalida');
    }

    newPassword = bcrypt.generatHash(newPassword);

    await datasource.updatePasswordById(payload['userid'], newPassword);
  }
}
