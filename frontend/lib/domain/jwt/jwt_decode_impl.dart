import 'package:frontend/domain/jwt/jwt_decode_service.dart';
import 'package:jwt_decode/jwt_decode.dart';

class JwtDecodeServiceImpl implements JwtDecodeService {
  @override
  Map<String, dynamic> getPayload(String token) {
    return Jwt.parseJwt(token);
  }

}
