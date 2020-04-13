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

  void toggleFavoriteStatus(String token, String userId) async {
    final url =
        'https://my-shop-a763e.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final respose = await Dio().put(url, data: isFavorite);
      print(respose.data);
    } on DioError catch (error) {
      print(error.response.data);
       isFavorite = oldStatus;
        notifyListeners();
    }
  }
}
