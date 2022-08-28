import 'package:bcrypt/bcrypt.dart';

import 'encrypt_service.dart';

class BCryptServiceImp implements EncryptService {
  @override
  bool checkHash(String password, String hash) {
    final bool checkPassword = BCrypt.checkpw(password, hash);

    return checkPassword;
  }

  @override
  String generateHash(String password) {
    final String hashed = BCrypt.hashpw(password, BCrypt.gensalt());

    return hashed;
  }
}
