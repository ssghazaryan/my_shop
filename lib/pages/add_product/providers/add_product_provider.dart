import 'package:flutter/material.dart';

class AddProductProvider with ChangeNotifier {
  bool _isLoading = false;
  String _barCode = '';
  final GlobalKey<FormState> formKey = GlobalKey();

  bool get isLoading {
    return _isLoading;
  }
  String get barCode {
    return _barCode;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
