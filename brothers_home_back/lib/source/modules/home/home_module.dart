import 'package:brothers_home/source/modules/home/datasource/home_datasource_impl.dart';
import 'package:brothers_home/source/modules/home/repository/home_repository.dart';
import 'package:brothers_home/source/modules/home/resource/home_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

class HomeModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.singleton<HomeDatasource>((i) => HomeDatasourceImpl(i())),
    Bind.singleton((i) => HomeRepository(i(), i())),
  ];

  @override
  List<Route> get routes => [
        Route.resource(HomeResource()),
      ];
}
