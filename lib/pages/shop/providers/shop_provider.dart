import 'package:MyShop/widgets/product_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../globals/globals.dart' as globals;
import '../../../globals/api_keys.dart' as api;

class ShopProvider with ChangeNotifier {
  bool _isLoading = false;
  List<ProductItem> _products = [];

  ShopProvider() {
    getData();
  }

  bool get isLoading {
    return _isLoading;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getData() async {
    setLoading(true);

    final url =
        'https://my-shop-a763e.firebaseio.com/shop_products/${globals.shop.shopId}.json?auth=${api.apiDatabase}';
    try {
      final response = await Dio().get(url);
      print(response.data);
    } on DioError catch (error) {
      print(error.response.data);
      setLoading(false);
    }
    notifyListeners();
    setLoading(false);
  }
}
