import 'package:flutter/services.dart';
import 'package:frontend/domain/category.dart';
import 'package:frontend/domain/home.dart';
import 'package:frontend/domain/user.dart';

class Invoice {
  late final int _id;
  late final User _user;
  late final Home _home;
  late Category _category;
  late int _price;
  late String _description;
  late DateTime _date;
  late ByteData _image;
  late bool? _paid;

  // static int _total_sum_price = 0;

  Invoice(
      {required int id,
      required User user,
      required Home home,
      required Category category,
      required int price,
      required DateTime date,
      required bool? paid,
      required String description,
      image}) {
    _id = id;
    _user = user;
    _home = home;
    _category = category;
    _price = price;
    _description = description;
    _date = date;
    _paid = paid;
    if (image != null) _image = image;

    // _total_sum_price += _price;
    // print("price: $_total_sum_price");
  }

  get id => _id;
  get user => _user;
  get home => _home;
  get category => _category;
  get price => _price;
  get description => _description;
  get date => _date;
  get image => _image;
  get paid => _paid;
}
