import 'package:frontend/domain/user.dart';

class Home {
  final int _id;
  late final String _name;  
  late final List<User> _users;

  Home(this._id);

  set name(name) => _name = name;
  set users(users) => _users = users;

  get id => _id;
  get name => _name;
  get users => _users;
}
