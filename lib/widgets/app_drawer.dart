import '../pages/auth/providers/auth.dart';
import '../pages/orders/screens/orders_screen.dart';
import '../pages/manage_products/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../globals/colors.dart' as col;
import '../globals/globals.dart' as globals;

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                radius: 20,
                backgroundColor: col.light,
                child: Icon(
                  Icons.account_circle,
                  size: 30,
                ),
              ),
              decoration:
                  BoxDecoration(color: Theme.of(context).appBarTheme.color),
              accountEmail: Text('${globals.user.email}'),
              accountName:
                  Text(globals.user.name + ' ' + globals.user.secondName),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.shop, color: Colors.white),
              title: Text('Shop'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.payment, color: Colors.white),
              title: Text('Orders'),
              onTap: () {
                //Navigator.of(context).pushReplacement(CustomRout(builder: (ctx) =>OrdersScreen()));
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.white),
              title: Text('Manage Products'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.white),
              title: Text('Logout'),
              onTap: () {
                //   Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
