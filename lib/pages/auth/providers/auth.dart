import 'dart:async';
import 'dart:convert';
import 'package:MyShop/models/user_model.dart';
import 'package:MyShop/pages/shops/screens/shops_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../globals/api_keys.dart' as api;
import '../../../globals/globals.dart' as globals;

class Auth with ChangeNotifier {
  bool _isLoading = false;
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  int _day = 0;
  int _month = 0;
  int _year = 0;
  int _sex = 0;
  bool firstTime = true;
  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final secondNameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final pass2Controller = TextEditingController();
  final List _days = [];
  final List _months = [];
  final List _years = [];
  final GlobalKey<FormState> formKey = GlobalKey();
  Map<String, String> authData = {
    'email': '',
    'password': '',
  };

  Auth() {
    setList();
    if (firstTime) {
      tryAutoLogin();
      firstTime = false;
    }
  }

  Future<void> submit(BuildContext context) async {
    if (!formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    formKey.currentState.save();
    setLoading(true);
    try {
      // if (_authMode == AuthMode.Login) {
      // Log user in
      await login(authData['email'], authData['password'], context);
      // } else {
      //   // Sign user up
      //   await Provider.of<Auth>(context, listen: false).signup(
      //     _authData['email'],
      //     _authData['password'],
      //   );
      // }
    } on DioError catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      print(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you. Please try again later';
      print(errorMessage);
    }
    setLoading(false);
  }

  void setSex(int val) {
    _sex = val;
    notifyListeners();
  }

  int get sex {
    return _sex;
  }

  void setDay(int val) {
    _day = val;
    notifyListeners();
  }

  void setMonth(int val) {
    _month = val;
    notifyListeners();
  }

  void setYear(int val) {
    _year = val;
    notifyListeners();
  }

  int get day {
    return _day;
  }

  int get month {
    return _month;
  }

  int get year {
    return _year;
  }

  List get days {
    return _days;
  }

  List get months {
    return _months;
  }

  List get years {
    return _years;
  }

  void setList() {
    _days.clear();
    _months.clear();
    _years.clear();
    for (int i = 0; i <= 31; i++) {
      if (i == 0)
        _days.add({'name': 'День'});
      else
        _days.add({'name': i.toString()});
    }
    for (int i = 0; i <= 12; i++) {
      if (i == 0)
        _months.add({'name': 'Месяц'});
      else
        _months.add({'name': i.toString()});
    }
    for (int i = 1949; i <= DateTime.now().year; i++) {
      if (i == 1949)
        _years.add({'name': 'Год'});
      else
        _years.add({'name': i.toString()});
    }
  }

  GlobalKey<FormState> get form {
    return _form;
  }

  bool get isAuth {
    return token != null;
  }

  bool get isLoading {
    return _isLoading;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment, context) async {
    setLoading(true);
    try {
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=${api.apiKey}";

      var match = {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      };
      print(match);
      final response = await Dio().post(url, data: match);

      if (response.statusCode == 200) {
        _token = response.data['idToken'];
        globals.token = _token;
        _userId = response.data['localId'];
        _expiryDate = DateTime.now().add(
          Duration(
            seconds: int.parse(response.data['expiresIn']),
          ),
        );
        _autoLogout();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String()
        });
        prefs.setString('userData', userData);

        if (urlSegment == 'signUp')
          await addUser();
        else
          await getUserData();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ShopsScreen(),
            ),
            (Route<dynamic> route) => false);

        // WidgetsBinding.instance
        //     .addPostFrameCallback((_) => nameController.dispose());
        // WidgetsBinding.instance
        //     .addPostFrameCallback((_) => secondNameController.dispose());
        // WidgetsBinding.instance
        //     .addPostFrameCallback((_) => emailController.dispose());
        // WidgetsBinding.instance
        //     .addPostFrameCallback((_) => passController.dispose());
        // WidgetsBinding.instance
        //     .addPostFrameCallback((_) => pass2Controller.dispose());
      }
    } on DioError catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
        content: Container(
          child: Text(e.response.data.toString()),
        ),
      ));
      print('error ${e.error}');
      print(e);
    }

    setLoading(false);
  }

  Future<void> addUser() async {
    final url = 'https://my-shop-a763e.firebaseio.com/users.json?auth=$_token';
    try {
      var match = {
        'userId': _userId,
        'name': nameController.text,
        'second_name': secondNameController.text,
        'email': emailController.text,
        'date': days[day]['name'] +
            '.' +
            months[month]['name'] +
            '.' +
            years[year]['name'],
        'sex': _sex.toString()
      };
      globals.user = UserModel(
        name: nameController.text,
        secondName: secondNameController.text,
        email: emailController.text,
        date: days[day]['name'] +
            '.' +
            months[month]['name'] +
            '.' +
            years[year]['name'],
        sex: _sex.toString(),
      );
      print(match);

      final response = await Dio().post(url, data: match);

      print(response.data);
      notifyListeners();
    } on DioError catch (error) {
      print(error.response.data);
      throw error;
    }
  }

  Future<void> signup({
    @required String email,
    @required String password,
    @required BuildContext context,
  }) async {
    print('signup');

    return _authenticate(email, password, 'signUp', context);
  }

  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    print('login');

    return _authenticate(email, password, 'signInWithPassword', context);
  }

  Future<bool> tryAutoLogin({BuildContext context}) async {
    if (context == null) return false;
    print('tryAutoLogin');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData'));
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    _token = extractedUserData['token'];
    globals.token = _token;

    _userId = extractedUserData['userId'];
    await getUserData();
    _expiryDate = expiryDate;

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    if (context != null)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ShopsScreen(),
          ),
          (Route<dynamic> route) => false);

    _autoLogout();
    notifyListeners();
    return true;
  }

  Future<void> getUserData() async {
    print('getUserData');
    var url =
        'https://my-shop-a763e.firebaseio.com/users.json?auth=${api.apiDatabase}';
    try {
      final response = await Dio().get(url);
      final data = response.data as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      data.forEach((key, value) {
        if (value['userId'] == _userId) {
          globals.user = UserModel(
            name: value['name'],
            date: value['date'],
            email: value['email'],
            secondName: value['second_name'],
            sex: value['sex'],
          );
        }
      });
    } on DioError catch (error) {
      print(error.response.data);
    }
  }

  void logout() async {
    _token = null;
    globals.token = _token;

    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> saveForm(BuildContext context) async {
    final bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    } else if (month == 0 || day == 0 || year == 1949) {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Container(
          child: Text('Укажите дату рождения'),
        ),
      ));
      // Toast.show("Укажите дату рождения", context,
      //     duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      return;
    }
    signup(
        password: passController.text,
        email: emailController.text,
        context: context);
  }
}
