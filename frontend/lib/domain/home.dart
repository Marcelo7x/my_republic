import 'package:frontend/domain/user.dart';

class Home {
  final int _id;
  final String _name;  
  final List<User> _users;

  Home(this._id, this._name, this._users);

  get id => _id;
  get name => _name;
  get users => _users;
}
