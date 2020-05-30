import 'package:flutter/material.dart';

class ShopsProvider with ChangeNotifier {
  String _name = '';
  String _addres = '';
  String _typeOfMag = '';
  bool _isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey();

  bool get isLoading {
    return _isLoading;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setName(String val) {
    _name = val;
    notifyListeners();
  }

  void setAddrees(String val) {
    _addres = val;
    notifyListeners();
  }

  String get addres {
    return _addres;
  }

  void setTypeOfMag(String val) {
    _typeOfMag = val;
    notifyListeners();
  }

  String get typeOfMag {
    return _typeOfMag;
  }

  String get text {
    return _name;
  }

  Future<void> saveMagazin() async {
    setLoading(true);

    await Future.delayed(Duration(seconds: 5));

    setLoading(false);
  }
}
