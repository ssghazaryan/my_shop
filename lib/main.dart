import 'package:MyShop/pages/registr_shops/screens/add_shop_screen.dart';
import 'package:MyShop/pages/shop/screens/shop_screen.dart';
import './pages/auth/screens/registration_scrren.dart';
import './helpers/custom_route.dart';
import './pages/auth/screens/auth_screen.dart';
import './pages/cart/screens/cart_screen.dart';
import './pages/orders/screens/orders_screen.dart';
import './pages/product_detail/screens/product_detail_screen.dart';
import './pages/manage_products/screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import './globals/colors.dart' as col;
import 'pages/registr_shops/screens/shops_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        // MultiProvider(
        //   providers: [
        // ChangeNotifierProvider.value(
        //     value: Auth(),
        //   ),
        //   ChangeNotifierProxyProvider<Auth, Products>(
        //     create: (BuildContext context) => Products(null, null, []),
        //     update: (BuildContext context, auth, previosProducts) => Products(
        //         auth.token,
        //         auth.userId,
        //         previosProducts == null ? [] : previosProducts.items),
        //   ),
        //   ChangeNotifierProvider.value(
        //     value: Cart(),
        //   ),
        //   ChangeNotifierProvider(
        //     create: (BuildContext context) => ShopsRegistrProvider(),
        //   ),
        //   ChangeNotifierProxyProvider<Auth, Orders>(
        //     create: (BuildContext context) => Orders(null, null, []),
        //     update: (BuildContext context, auth, previosOrders) => Orders(
        //         auth.token,
        //         auth.userId,
        //         previosOrders == null ? [] : previosOrders.orders),
        //   ),
        // ],
        // child:
        // Consumer<AuthProvider>(
        //   builder: (ctx, auth, _) =>
        MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Shop',
      theme: ThemeData(
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.green),
          buttonTheme: ButtonThemeData(
            buttonColor: col.light,
            highlightColor: Theme.of(context).scaffoldBackgroundColor,
            splashColor: Colors.green,
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
      home: AuthScreen(),
      routes: {
        ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
        ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
        CartScreen.routeName: (ctx) => CartScreen(),
        OrdersScreen.routeName: (ctx) => OrdersScreen(),
        UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
        EditProductScreen.routeName: (ctx) => EditProductScreen(),
        AuthScreen.routeName: (ctx) => AuthScreen(),
        RegitrationScreen.routeName: (ctx) => RegitrationScreen(),
        ShopsRegistrScreen.routeName: (ctx) => ShopsRegistrScreen(),
        AddShopScreen.routeName: (ctx) => AddShopScreen(),
      },
      //   ),
      // ),
    );
  }
}
