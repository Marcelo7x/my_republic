import 'package:frontend/domain/home.dart';

class User {
  final int _id;
  final String _name;
  late final Home _home;

  User(this._id, this._name, {Home? home}) {
    if(home != null) _home = home;
  }

  get id => _id;
  get name => _name;
  get home_id => _home.id;

  setHome(Home home) => _home = home;
}
