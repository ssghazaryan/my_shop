import 'package:MyShop/widgets/app_drawer.dart';
import 'package:MyShop/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' as provider;

class OrdersScreen extends StatelessWidget {
  static const routName = '/order-screen';
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<provider.Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.orders.length,
        itemBuilder: (ctx, index) {
          return OrderItem(orders.orders[index]);
        }),
        drawer: AppDrawer(),
    );
  }
}
