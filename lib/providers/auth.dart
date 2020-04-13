import 'package:MyShop/models/rest_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId{
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAQVUeJifi6PFOPNynFYcCtQEuPR2Ylm98";

    try {
      final response = await Dio().post(url, data: {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      });
   // print(response.data);
      _token = response.data['idToken'];
      _userId = response.data['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(response.data['expiresIn']),
        ),
      );
      notifyListeners();
    } on DioError catch (error) {
      if (error.response.data['error'] != null) {
        throw RestException(error.response.data['error']['message']);
      }
      print(error.response.data);
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
