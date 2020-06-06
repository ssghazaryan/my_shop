import 'package:MyShop/func/logout.dart';
import 'package:MyShop/pages/registr_shops/providers/shops_provider.dart';
import 'package:MyShop/pages/registr_shops/screens/add_shop_screen.dart';
import 'package:MyShop/pages/shop/screens/shop_screen.dart';
import 'package:MyShop/widgets/get_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../globals/globals.dart' as globals;

class ShopsRegistrScreen extends StatelessWidget {
  static const routeName = '/shops-screen';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ShopsRegistrProvider(),
        )
      ],
      child: ShopsRegistrScreenChild(),
    );
  }
}

class ShopsRegistrScreenChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopsRegistrProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          provider.setdefault();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddShopScreen(provider),),);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Выбор Магазина'),
        leading: CloseButton(
          onPressed: () {
            logout();
            Navigator.pushNamed(context, '/');
          },
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: provider.isLoading
            ? PreLoader(
                color: false,
                marigin: true,
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: [
                      for (int i = 0; i < provider.shopsList.length; i++)
                        RaisedButton(
                          highlightColor: Colors.green,
                          onPressed: () {
                            globals.shop = provider.shopsList[i];
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ProductsOverviewScreen()),
                                (route) => false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              provider.shopsList[i].name,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
