import 'package:flutter/services.dart';
import 'package:frontend/domain/category.dart';
import 'package:frontend/domain/home.dart';
import 'package:frontend/domain/user.dart';

class Invoice {
  final int _id;
  final User _user;
  final Home _home;
  Category _category;
  int _price;
  DateTime _date;
  ByteData _image;
  bool? _paid;

  Invoice(this._id, this._user, this._home, this._category, this._price, this._date, this._image, this._paid);

  get id => _id;
  get user => _user;
  get home => _home;
  get category => _category;
  get price => _price;
  get date => _date;
  get image => _image;
  get paid => _paid;

}
