import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../globals/api_keys.dart' as api;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:path/path.dart' as Path;
import '../../../globals/globals.dart' as globals;

class AddProductProvider with ChangeNotifier {
  bool _isLoading = false;
  final controllerBarCode = TextEditingController();
  final controllerProductName = TextEditingController();
  final controllerProductPrice = TextEditingController();
  final controllerProductImageUrl = TextEditingController();
  final controllerProductWeight = TextEditingController();
  final controllerProductCount = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  String _imagePath = '';
  File _image;

  bool get isLoading {
    return _isLoading;
  }

  String get imagePath {
    return _imagePath;
  }

  void setPrice(String value) {
    controllerProductPrice.text = value;
    notifyListeners();
  }

  void setImagePath(String value, File file) {
    _imagePath = value;
    _image = file;
    notifyListeners();
  }

  void setCount(String value) {
    controllerProductCount.text = value;
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
    setLoading(true);
    final url =
        'https://my-shop-a763e.firebaseio.com/products/$value.json?auth=${api.apiDatabase}';
    try {
      final response = await Dio().get(url);

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
          controllerProductCount.text = '';
        }
      } else {
        print('Товар не найден');
        controllerBarCode.text = value;
        controllerProductName.text = '';
        controllerProductImageUrl.text = '';
        controllerProductWeight.text = '';
        controllerProductPrice.text = '';
        controllerProductCount.text = '';
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

    if (controllerProductImageUrl.text == '') {
      String imageurl = await uploadFile();

      final url =
          'https://my-shop-a763e.firebaseio.com/products/${controllerBarCode.text}.json?auth=${api.apiDatabase}';
      try {
        var match = {
          'barcode': controllerBarCode.text,
          'name': controllerProductName.text,
          'image': imageurl,
          'price': controllerProductPrice.text,
          'weight': controllerProductWeight.text,
          'count': controllerProductCount.text
        };
        final response = await Dio().post(url, data: match);

        print(response.data);
        notifyListeners();
      } on DioError catch (error) {
        print(error.response.data);
        setLoading(false);
      }
    }
    final url =
        'https://my-shop-a763e.firebaseio.com/shop_products/${globals.shop.shopId}.json?auth=${api.apiDatabase}';
    try {
      var match = {
        'barcode': controllerBarCode.text,
        'name': controllerProductName.text,
        'image': controllerProductImageUrl.text,
        'price': controllerProductPrice.text,
        'weight': controllerProductWeight.text,
        'count': controllerProductCount.text
      };
      print('asd');
      final response = await Dio().post(url, data: match);
      print(response.statusCode);
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

  Future<String> uploadFile() async {
    String _uploadedFileURL = '';
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('products')
        .child(Path.basename(_image.path));
    print(storageReference.path);

    StorageUploadTask uploadTask = storageReference.putFile(_image);

    await uploadTask.onComplete;
    await storageReference.getDownloadURL().then((fileURL) {
      _uploadedFileURL = fileURL;
    });
    return _uploadedFileURL;
  }
}
