import 'package:brothers_home/source/services/dot_env.dart';
import 'package:brothers_home/source/services/jwt/jwt_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtServiceImp implements JwtService {
  final DotEnvService dotEnvService;

  JwtServiceImp(this.dotEnvService);

  @override
  String generateToken(Map claims, String audience) {
    // Create a json web token
    final jwt = JWT(
      claims,
      audience: Audience.one(audience), // acessToken or refreshToken
    );

    // Sign it (default with HS256 algorithm)
    final token = jwt.sign(SecretKey(dotEnvService['JWT_KEY']!));

    print('Signed token: $token\n');
    return token;
  }


  @override
  // Verify a token
  void verifyToken(String token, String audience) {
      final jwt = JWT.verify(
        token,
        SecretKey(dotEnvService['JWT_KEY']!),
        audience: Audience.one(audience),
      );
      print('Payload: ${jwt.payload}');
  }
  
  @override
  Map getPayload(String token) {
    final jwt = JWT.verify(
        token,
        SecretKey(dotEnvService['JWT_KEY']!),
        checkExpiresIn: false,
        checkHeaderType: false,
        checkNotBefore: false,
      );

      return jwt.payload;
  }

  
}
