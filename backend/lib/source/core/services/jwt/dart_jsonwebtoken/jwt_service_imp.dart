import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../../dotenv/dot_env.dart';
import '../jwt_service.dart';

class JwtServiceImp implements JwtService {
  final DotEnvService dotEnv;

  JwtServiceImp(this.dotEnv);

  // String _key = 'AAAAB3NzaC1yc2EAAAADAQABAAABgQDJ4GC7DEbWNUvOYo4IeT1/QKI/qh7FHJ7iLmRhgm3mths+4RUTGq7ja5DcfPRsFfm8rBbr6xHcVPzMvXtp/uUy7mwkZkhIL3bMV0deV7dV2kb9zsaSCtZ1L+q5p5nTf6KWg6ML3EBsCZC0MfAvPYPvMrCs0QMTWXDhXcfTP2w2W+uQJOf7JDkzSWL1sRi0Pn2jv1FtDVUtpRPhQoOoz1d/zkN2aZ0EXMCZvoO6vl4MtkNNIY5ygSgqVI8UH79/HQrtGH71sl6KCWHUHSM2agNyGJl025J2boHmcPT2F74suU6HBd4tMR1NjM4TBjxNV4wRrloaF05bovn8ybA3s7BfpQE6OciSxhhuga4EVX0f9YyRr1RAfbKjb+28FfUWtcjXNg7mIsqrIP+aM/IfppOG6e9ofGt0QFsDarRv31yHgWnvJvyDV+H7EMXF1iHb77XyQnCpmU6XB0mjc6r5we7Nvo1j0/u5ugytrQRJ6hPL7fvvJbRxrRCOeW8WGaeqb+E=';

  @override
  String generateToken(Map claims, String audience) {
    // Create a json web token
    final jwt = JWT(
      claims,
      audience: Audience.one(audience), // acessToken or refreshToken
    );

    // Sign it (default with HS256 algorithm)
    final token = jwt.sign(SecretKey(dotEnv['JWT_KEY']));
    // final token = jwt.sign(SecretKey(_key));

    print('Signed token: $token\n');
    return token;
  }

  @override
  // Verify a token
  void verifyToken(String token, String audience) {
    final jwt = JWT.verify(
      token,
      SecretKey(dotEnv['JWT_KEY']),
      // SecretKey(_key),
      audience: Audience.one(audience),
    );
    print('Payload: ${jwt.payload}');
  }

  @override
  Map getPayload(String token) {
    final jwt = JWT.verify(
      token,
      SecretKey(dotEnv['JWT_KEY']),
      // SecretKey(_key),
      checkExpiresIn: false,
      checkHeaderType: false,
      checkNotBefore: false,
    );

    return jwt.payload;
  }
}
