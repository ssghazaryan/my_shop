import 'package:MyShop/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import '../providers/products_provider.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
      ),
      body: SafeArea(
        child: Container(
          child: ProductGrid(),
        ),
      ),
    );
  }
}
