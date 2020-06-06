import 'package:MyShop/pages/auth/screens/registration_scrren.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../globals/colors.dart' as col;
import '../../../globals/globals.dart' as globals;

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        )
      ],
      child: AuthScreenChild(),
    );
  }
}

class AuthScreenChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    globals.globalContext = context;
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: provider.isLoading
          ? SpinKitFoldingCube(
              color: Colors.white,
              size: 50.0,
            )
          : Builder(
              builder: (context) => Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [col.light, col.darkColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0, 1],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: deviceSize.height,
                      width: deviceSize.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20.0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 94.0),
                              // transform: Matrix4.rotationZ(-8 * pi / 180)
                              //   ..translate(-10.0),
                              // ..translate(-10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: col.darkColor,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8,
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Text(
                                'YourShop',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .accentTextTheme
                                      .title
                                      .color,
                                  fontSize: 50,
                                  fontFamily: 'Anton',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                              flex: deviceSize.width > 600 ? 2 : 1,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 8.0,
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: 260,
                                  curve: Curves.easeIn,
                                  //  height: _heightAnimation.value.height,
                                  constraints: BoxConstraints(minHeight: 300),
                                  width: deviceSize.width * 0.75,
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Form(
                                      key: provider.formKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          TextFormField(
                                            decoration: InputDecoration(
                                                labelText: 'Электронный адрес'),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: (value) {
                                              if (value.isEmpty ||
                                                  !value.contains('@')) {
                                                return 'Invalid email!';
                                              } else
                                                return null;
                                            },
                                            onSaved: (value) {
                                              provider.authData['email'] =
                                                  value;
                                            },
                                          ),
                                          TextFormField(
                                            decoration: InputDecoration(
                                                labelText: 'Пароль'),
                                            obscureText: false,
                                            validator: (value) {
                                              if (value.isEmpty ||
                                                  value.length < 5) {
                                                return 'Password is too short!';
                                              } else
                                                return null;
                                            },
                                            onSaved: (value) {
                                              provider.authData['password'] =
                                                  value;
                                            },
                                          ),
                                          // AnimatedContainer(
                                          //   curve: Curves.easeIn,
                                          //   constraints: BoxConstraints(
                                          //       minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                                          //       maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                                          //   duration: Duration(milliseconds: 300),
                                          //   child: SlideTransition(
                                          //     position: _slideAnimation,
                                          //     child: TextFormField(
                                          //       enabled: _authMode == AuthMode.Signup,
                                          //       decoration:
                                          //           InputDecoration(labelText: 'Confirm Password'),
                                          //       obscureText: false,
                                          //       validator: _authMode == AuthMode.Signup
                                          //           ? (value) {
                                          //               if (value != _passwordController.text) {
                                          //                 return 'Passwords do not match!';
                                          //               }
                                          //             }
                                          //           : null,
                                          //     ),
                                          //   ),
                                          // ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          if (provider.isLoading)
                                            CircularProgressIndicator()
                                          else
                                            RaisedButton(
                                              child: Text('Вход'),
                                              onPressed: () =>
                                                  provider.submit(),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 30.0,
                                                  vertical: 8.0),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              textColor: Theme.of(context)
                                                  .primaryTextTheme
                                                  .button
                                                  .color,
                                            ),
                                          FlatButton(
                                            child: Text('Регистрация'),
                                            onPressed: () {
                                              Navigator.pushNamed(context,
                                                  RegitrationScreen.routeName);
                                            },
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 30.0, vertical: 4),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            textColor:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
