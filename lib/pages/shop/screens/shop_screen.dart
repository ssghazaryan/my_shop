import 'package:MyShop/pages/shop/providers/shop_provider.dart';

import '../../../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../globals/globals.dart' as globals;

class ProductsOverviewScreen extends StatelessWidget {
  static const routeName = '/product-overview-screen';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ShopProvider(),
        )
      ],
      child: ProductsOverviewScreenChild(),
    );
  }
}

class ProductsOverviewScreenChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopProvider>(context);
    globals.globalContext = context;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Товары'),
      ),
      drawer: AppDrawer(),
      body: provider.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {
                // return Provider.of<Products>(context, listen: false)
                //     .getProductsFromDatabase()
                //     .then((_) {
                //   setState(() {
                //     _isLoaading = false;
                //   });
                // });
              },
              child: SafeArea(
                child: Container(
                  child: Container(),
                ),
              ),
            ),
    );
  }
}
