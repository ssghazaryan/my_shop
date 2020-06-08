import 'package:flutter/material.dart';

class ProductItem {
  final String barcode;
  final String count;
  final String image;
  final String name;
  final String price;
  final String weight;
  ProductItem({
    @required this.barcode,
    @required this.count,
    @required this.image,
    @required this.name,
    @required this.price,
    @required this.weight,
  });
}
