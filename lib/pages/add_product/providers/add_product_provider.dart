import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../globals/api_keys.dart' as api;

class AddProductProvider with ChangeNotifier {
  bool _isLoading = false;
  final controllerBarCode = TextEditingController();
  final controllerProductName = TextEditingController();
  final controllerProductPrice = TextEditingController();
  final controllerProductImageUrl = TextEditingController();
  final controllerProductWeight = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  bool get isLoading {
    return _isLoading;
  }

  void setPrice(String value) {
    controllerProductPrice.text = value;
    notifyListeners();
  }

  void setWeight(String value) {
    controllerProductWeight.text = value;
    notifyListeners();
  }

  void setName(String value) {
    controllerProductName.text = value;
    notifyListeners();
  }

  void setImage(String value) {
    controllerProductImageUrl.text = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getProduct(String value) async {
    print(value);
    setLoading(true);
    final url =
        'https://my-shop-a763e.firebaseio.com/products/$value.json?auth=${api.apiDatabase}';
    try {
      final response = await Dio().get(url);

      print(response.data);
      if (response.data != null) {
        Map data = response.data;
        print('Товар найден');
        if (data.length == 1) {
          var item = data.values.elementAt(0);
          controllerBarCode.text = item['barcode'].toString();
          controllerProductName.text = item['name'].toString();
          controllerProductImageUrl.text = item['image'].toString();
          controllerProductWeight.text = item['weight'].toString();
          controllerProductPrice.text = item['price'].toString();
        }
      } else {
        print('Товар не найден');
        controllerBarCode.text = value;
        controllerProductName.text = '';
        controllerProductImageUrl.text = '';
        controllerProductWeight.text = '';
        controllerProductPrice.text = '';
      }
      notifyListeners();
    } on DioError catch (error) {
      print(error.response.data);
      setLoading(false);
    }
    setLoading(false);
  }

  Future<void> sendNewProduct() async {
    setLoading(true);
    final url =
        'https://my-shop-a763e.firebaseio.com/products/${controllerBarCode.text}.json?auth=${api.apiDatabase}';
    try {
      var match = {
        'barcode': controllerBarCode.text,
        'name': controllerProductName.text,
        'image': controllerProductImageUrl.text,
        'price': controllerProductPrice.text,
        'weight': controllerProductWeight.text,
      };

      final response = await Dio().post(url, data: match);

      print(response.data);
      notifyListeners();
    } on DioError catch (error) {
      print(error.response.data);
      setLoading(false);
    }
    setLoading(false);
  }

  void setBarCode(String string) {
    controllerBarCode.text = string;
    notifyListeners();
  }
}
