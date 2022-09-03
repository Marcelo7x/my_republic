import 'package:frontend/domain/home.dart';

class User {
  final int _id;
  late final String _name;
  late final Home _home;

  User(this._id, {String? name, Home? home}) {
    if (home != null) _home = home;
    if (name != null) _name = name;
  }

  get id => _id;
  String get name => _name;
  get home_id => _home.id;

  setHome(Home home) => _home = home;
  set name(String name) => _name;

  factory User.fromMap(Map<String, dynamic> map) {
    User user = User(map['userid']);
    if (map['firstname'] != null) user.name = map['firstname'];

    return user;
  }
}
