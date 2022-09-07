import 'dart:convert';

class UserModel {
  String? firstName;
  String? lastName;
  String? password;
  String? email;
  int? homeid;
  int? userid;

  UserModel(
      {int? userid,
      String? firstName,
      String? lastName,
      String? email,
      String? password,
      int? homeid}) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.password = password;
    this.userid = userid;
    this.homeid = homeid;
  }

  Map<String, dynamic> userInformaitionToMap() {
    return {
      "userid":userid,
      "firstname": firstName,
      "lastname": lastName,
      "email": email,
      "homeid": homeid,
    };
  }

  dynamic userInformaitionToJson() => jsonEncode(userInformaitionToMap());

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['firstname'],
      lastName: map['lastname'],
      password: map['password'],
      email: map['email'],
      userid: map['userid'],
      homeid: map['homeid'],
    );
  }
}
