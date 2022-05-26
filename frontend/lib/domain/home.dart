import 'package:frontend/domain/user.dart';

class Home {
  final int _id;
  late final String _name;  
  late final List<User> _users;

  Home(this._id);

  set name(name) => _name = name;
  set users(users) => _users = users;

  int get id => _id;
  String get name => _name;
  List<User> get users => _users;
}
