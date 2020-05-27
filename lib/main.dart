import './pages/auth/screens/registration_scrren.dart';
import './pages/auth/providers/registration_provider.dart';
import './helpers/custom_route.dart';
import './pages/auth/providers/auth.dart';
import './pages/auth/screens/auth_screen.dart';
import './pages/cart/providers/cart.dart';
import './pages/cart/screens/cart_screen.dart';
import './pages/orders/providers/orders.dart';
import './pages/orders/screens/orders_screen.dart';
import './pages/product_detail/screens/product_detail_screen.dart';
import './pages/product_screen/screens/products_overview_screen.dart';
import './pages/manage_products/screens/user_products_screen.dart';

import './screens/splash_screen.dart';
import './screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/products_provider.dart';
import './globals/colors.dart' as col;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (BuildContext context) => Products(null, null, []),
          update: (BuildContext context, auth, previosProducts) => Products(
              auth.token,
              auth.userId,
              previosProducts == null ? [] : previosProducts.items),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: RegistrationProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (BuildContext context) => Orders(null, null, []),
          update: (BuildContext context, auth, previosOrders) => Orders(
              auth.token,
              auth.userId,
              previosOrders == null ? [] : previosOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My Shop',
          theme: ThemeData(
              buttonTheme: ButtonThemeData(
                buttonColor: col.light,
                highlightColor: Theme.of(context).scaffoldBackgroundColor,
                splashColor: Colors.greenAccent,
              ),
              textTheme: TextTheme(
                bodyText1: TextStyle(color: Colors.white),
                bodyText2: TextStyle(color: Colors.white),
              ),
              iconTheme: IconThemeData(color: Colors.white),
              scaffoldBackgroundColor: col.darkColor,
              appBarTheme: AppBarTheme(color: col.lowDarkColor),
              primarySwatch: Colors.blue,
              accentColor: Colors.deepOrange,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              })),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (BuildContext context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            RegitrationScreen.routeName: (ctx) => RegitrationScreen(),
          },
        ),
      ),
    );
  }
}
