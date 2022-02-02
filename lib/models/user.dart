import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:new_motel/constants/shared_preferences_keys.dart';

class User {
  int id;
  String first_name;
  String last_name;
  String email;
  String password;
  // String resetLink;
  // String phone;
  //int RestaurantId;
  DateTime createdAt;
  DateTime updatedAt;
  int status;

  User(
      {required this.id,
      required this.first_name,
      required this.last_name,
      required this.email,
      required this.password,
      // this.resetLink,
      // this.phone,
        required this.status,
      required this.createdAt,
      required this.updatedAt});
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": first_name,
      "last_name": last_name,
      "email": email,
      "password": password,
      // "resetLink": resetLink,
      // "phone": phone,
    };
  }

  factory User.fromJson(Map<String, dynamic> item) {
    return User(
      id: item['id'],
      first_name: item['first_name'],
      last_name: item['last_name'],
      email: item['email'],
      password: item['password'],
      // phone: item['phone'],
      // resetLink: item['resetLink'],
      status: item['status'],
      createdAt: DateTime.parse(item['createdAt']),
      updatedAt: item['updatedAt'] != null
          ? DateTime.parse(item['updatedAt'])
          : DateTime.parse(item['updatedAt']),
    );
  }

}
