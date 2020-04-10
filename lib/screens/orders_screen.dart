import 'package:MyShop/widgets/app_drawer.dart';
import 'package:MyShop/widgets/order_item.dart' as order;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' as provider;

class OrdersScreen extends StatelessWidget {
//   static const routName = '/order-screen';

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
  // bool _isLoaading = true;

  // @override
  // void initState() {
  //   //Future.delayed(Duration.zero).then((value)  async {

  //   // Provider.of<provider.Orders>(context, listen: false)
  //   //     .fetchAndSetOrders()
  //   //     .then((_) {
  //   //   setState(() {
  //   //     _isLoaading = false;
  //   //   });
  //   // });
  //   // });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    print('orderData');
    //  final orders = Provider.of<provider.Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
          future: Provider.of<provider.Orders>(context, listen: false)
              .fetchAndSetOrders(),
          builder: (ctx, snapshat) {
            if (snapshat.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshat.error != null) {
                return Center(
                  child: Text('An error occurred!'),
                );
              } else {
                return Consumer<provider.Orders>(
                    builder: (ctx, orderData, child) => ListView.builder(
                        itemCount:  orderData.orders.length,
                        itemBuilder: (ctx, index) {
                          return order.OrderItem(orderData.orders[index]);
                        }));
              }
            }
          }),
      drawer: AppDrawer(),
    );
  }
}
