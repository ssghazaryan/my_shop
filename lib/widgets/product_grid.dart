import 'package:MyShop/providers/product.dart';
import '../widgets/product_item.dart';
import 'package:flutter/material.dart';
import '../providers/products_provider.dart';
import 'package:provider/provider.dart';


class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData  = Provider.of<Products>(context);
    final products = productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (btx, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(
          // title: products[index].title,
          // id: products[index].id,
          // imageUrl: products[index].imageUrl,
        ),);
      },
    );
  }
}