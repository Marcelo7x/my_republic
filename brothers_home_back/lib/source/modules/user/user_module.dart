import 'package:brothers_home/source/modules/user/datasource/user_datasource_impl.dart';
import 'package:brothers_home/source/modules/user/repository/user_repository.dart';
import 'package:brothers_home/source/modules/user/resource/user_resourse.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.singleton<UserDatasource>((i) => UserDatasourceImpl(i())),
    Bind.singleton<UserRepository>((i) => UserRepository(i(), i()))
  ];

  @override
  List<ModularRoute> get routes => [
    Route.resource(UserResource())
  ];
}
