import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    final url = 'https://my-shop-a763e.firebaseio.com/products/$id.json';
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    Dio().patch(url, data: {'isFavorite': isFavorite}).catchError((value) {
      isFavorite = oldStatus;
      notifyListeners();
    });
  }
}
