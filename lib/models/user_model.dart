import 'package:flutter/material.dart';

class UserModel {
  final String name;
  final String secondName;
  final String email;
  final String date;
  final String sex;

  UserModel({
    @required this.name,
    @required this.secondName,
    @required this.email,
    @required this.date,
    @required this.sex,
  });
}
