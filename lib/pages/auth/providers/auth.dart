import 'dart:async';
import 'dart:convert';
import 'package:MyShop/models/user_model.dart';
import 'package:MyShop/pages/registr_shops/screens/shops_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../globals/api_keys.dart' as api;
import '../../../globals/globals.dart' as globals;

class AuthProvider with ChangeNotifier {
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

  AuthProvider() {
    setList();
    tryAutoLogin();
  }

  Future<void> submit() async {
    if (!formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    formKey.currentState.save();
    login(authData['email'], authData['password']);
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
      String email, String password, String urlSegment) async {
    setLoading(true);

    try {
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=${api.apiKey}";

      print(api.apiKey);
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
      // Scaffold.of(
      //   globals.globalContext,
      // ).showSnackBar(SnackBar(
      //   duration: Duration(seconds: 5),
      //   backgroundColor: Colors.red,
      //   content: Container(
      //     child: Text(e.response.data.toString()),
      //   ),
      // ));
      print('error ${e.error}');
      print('error ${e.response.data}');
      print(e);
    }

    setLoading(false);
  }

  Future<void> addUser() async {
    // final url =
    //     'https://my-shop-a763e.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    final url =
        'https://my-shop-a763e.firebaseio.com/users/$userId.json?auth=${api.apiDatabase}';
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
        userID: _userId,
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
      Navigator.pushAndRemoveUntil(
          globals.globalContext,
          MaterialPageRoute(
            builder: (BuildContext context) => ShopsRegistrScreen(),
          ),
          (Route<dynamic> route) => false);

      print(response.data);
      notifyListeners();
    } on DioError catch (error) {
      print('addUser ${error.response.data}');
      throw error;
    }
  }

  Future<void> signup({
    @required String email,
    @required String password,
    @required BuildContext context,
  }) async {
    print('signup');

    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    print('login');

    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> tryAutoLogin() async {
    setLoading(true);

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      setLoading(false);
      return;
    }
    final extractedUserData = json.decode(prefs.getString('userData'));
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    _token = extractedUserData['token'];
    globals.token = _token;

    _userId = extractedUserData['userId'];
    await getUserData();
    _expiryDate = expiryDate;

    if (expiryDate.isBefore(DateTime.now())) {
      setLoading(false);
      return;
    }

    _autoLogout();
    notifyListeners();
    setLoading(false);

    return true;
  }

  Future<void> getUserData() async {
    var url =
        'https://my-shop-a763e.firebaseio.com/users/$_userId.json?auth=${api.apiDatabase}';
    try {
      final response = await Dio().get(url);
      final data = response.data as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      print(data);

      data.forEach((key, value) {
        globals.user = UserModel(
          userID: _userId,
          name: value['name'],
          date: value['date'],
          email: value['email'],
          secondName: value['second_name'],
          sex: value['sex'],
        );
      });
      Navigator.pushAndRemoveUntil(
          globals.globalContext,
          MaterialPageRoute(
            builder: (BuildContext context) => ShopsRegistrScreen(),
          ),
          (Route<dynamic> route) => false);
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
