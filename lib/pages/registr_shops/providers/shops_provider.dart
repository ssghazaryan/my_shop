import 'package:MyShop/models/shop_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../globals/api_keys.dart' as api;
import '../../../globals/globals.dart' as globals;

class ShopsRegistrProvider with ChangeNotifier {
  String _name = '';
  String _addres = '';
  String _typeOfMag = '';
  bool _creatingMagazin = false;
  bool _isLoading = false;
  bool _firstTime = true;
  List<ShopModel> _shopsList = [];
  final GlobalKey<FormState> formKey = GlobalKey();

  ShopsRegistrProvider({bool getData = false}) {
    if (_firstTime) {
      _firstTime = false;
      getShops();
    }
  }


  setdefault() {
    _name = '';
    _addres = '';
    _typeOfMag = '';
    _creatingMagazin = false;
  }

  bool get creatingMagazin {
    return _creatingMagazin;
  }

  List<ShopModel> get shopsList {
    return _shopsList;
  }

  bool get isLoading {
    return _isLoading;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setCreatingMagazin(bool value) {
    _creatingMagazin = value;
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

  Future<void> getShops() async {
    print('getShops');
    print(globals.user.name);
    setLoading(true);
    if (globals.user != null) if (globals.user.userID != null) {
      final url =
          'https://my-shop-a763e.firebaseio.com/shops/${globals.user.userID}.json?auth=${api.apiDatabase}';
      try {
        globals.shop = ShopModel(
          name: _name,
          addres: _addres,
          date: DateTime.now(),
          creatorId: globals.user.userID,
          type: _typeOfMag,
        );

        final response = await Dio().get(url);

        _shopsList.clear();

        if (response.data != null) {
          Map temp = response.data;
          temp.forEach((key, value) {
            _shopsList.add(
              ShopModel(
                name: value['name'],
                addres: value['addres'],
                creatorId: value['creatorId'],
                date: DateTime.parse(value['date']),
                type: value['type'],
              ),
            );
          });
        }
        notifyListeners();
      } on DioError catch (error) {
        print(error.response.data);
        setLoading(false);
      }
    }
    setLoading(false);
  }

  Future<void> saveMagazin() async {
    setCreatingMagazin(true);
    final url =
        'https://my-shop-a763e.firebaseio.com/shops/${globals.user.userID}.json?auth=${api.apiDatabase}';
    try {
      var match = {
        'creatorId': globals.user.userID,
        'name': _name,
        'addres': _addres,
        'date': DateTime.now().toIso8601String(),
        'type': _typeOfMag
      };

      globals.shop = ShopModel(
        name: _name,
        addres: _addres,
        date: DateTime.now(),
        creatorId: globals.user.userID,
        type: _typeOfMag,
      );

      final response = await Dio().post(url, data: match);

      print(response.data);
      notifyListeners();
    } on DioError catch (error) {
      print(error.response.data);
      setLoading(false);
    }
    setCreatingMagazin(false);
  }
}
