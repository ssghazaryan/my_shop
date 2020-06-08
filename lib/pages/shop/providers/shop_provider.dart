import 'package:MyShop/models/product_model.dart';
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

  List<ProductItem> get products {
    return _products;
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

      if (response.statusCode == 200) {
        _products.clear();
        Map data = response.data;
        if (data != null) {
          data.forEach((key, value) {
            _products.add(
              ProductItem(
                name: value['name'],
                count: value['count'],
                barcode: value['barcode'],
                image: value['image'],
                price: value['price'],
                weight: value['weight'],
              ),
            );
          });
        }
      }
    } on DioError catch (error) {
      print(error.response.data);
      setLoading(false);
    }
    notifyListeners();
    setLoading(false);
  }
}
