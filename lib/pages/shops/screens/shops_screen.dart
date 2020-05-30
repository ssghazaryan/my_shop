import 'package:MyShop/pages/shops/screens/add_shop_screen.dart';
import 'package:flutter/material.dart';

class ShopsScreen extends StatelessWidget {
  static const routeName = '/shops-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выбор Магазина'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: RaisedButton(
                highlightColor: Colors.green,
                onPressed: () {
                  Navigator.pushNamed(context, AddShopScreen.routeName);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Создать магазин',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
