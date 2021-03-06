import 'package:flutter/material.dart';

class ShopModel {
  final String shopId;
  final String creatorId;
  final String name;
  final String addres;
  final DateTime date;
  final String type;

  ShopModel({
    @required this.shopId,
    @required this.creatorId,
    @required this.name,
    @required this.addres,
    @required this.date,
    @required this.type,
  });
}
