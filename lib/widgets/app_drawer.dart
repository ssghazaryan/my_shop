import 'package:MyShop/func/logout.dart';
import 'package:MyShop/pages/cassa/screens/cassa_screen.dart';
import 'package:MyShop/pages/shop/screens/shop_screen.dart';
import 'package:MyShop/pages/warehouse/screens/ware_house_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:flutter/material.dart';
import '../globals/globals.dart' as globals;

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 15.0,
                      offset: Offset(0.0, 0.75))
                ],
                color: Theme.of(context).appBarTheme.color,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              globals.user.name + ' ' + globals.user.secondName,
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${globals.user.email}',
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      globals.shop.name,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),

            // Divider(),
            // ListTile(
            //   leading:
            //       Icon(MaterialIcons.store_mall_directory, color: Colors.white),
            //   title: Text('Магазины'),
            //   onTap: () {
            //     Navigator.of(context).pushReplacementNamed('/');
            //   },
            // ),
            Divider(),
            ListTile(
              leading: Icon(MaterialCommunityIcons.account_group,
                  color: Colors.white),
              title: Text('Работники'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(MaterialCommunityIcons.cards, color: Colors.white),
              title: Text('Товары'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(ProductsOverviewScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(MaterialCommunityIcons.cash_register,
                  color: Colors.white),
              title: Text('Касса'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => CassaScreen()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(MaterialCommunityIcons.garage, color: Colors.white),
              title: Text('Склад'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => WareHouse()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.white),
              title: Text('Выйти'),
              onTap: () {
                logout();
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
