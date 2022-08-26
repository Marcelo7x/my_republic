abstract class EncryptService {
  String generatHash(String password);
  bool checkHash(String password, String hash);
}
