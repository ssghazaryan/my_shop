import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product-item';

  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<Products>(context,listen: false).getProductsFromDatabase();
  }
 
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context) ,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: products.items.length,
              itemBuilder: (_, index) {
                return Column(
                  children: <Widget>[
                    UserProductItem(
                      id: products.items[index].id,
                      imageUrl: products.items[index].imageUrl,
                      title: products.items[index].title,
                      description: products.items[index].description,
                      price: products.items[index].price,
                    ),
                    Divider()
                  ],
                );
              }),
        ),
      ),
    );
  }
}
