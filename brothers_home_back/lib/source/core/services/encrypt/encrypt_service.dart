abstract class EncryptService {
  String generateHash(String password);
  bool checkHash(String password, String hash);
}
