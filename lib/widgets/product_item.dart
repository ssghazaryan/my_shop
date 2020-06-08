import '../pages/auth/providers/auth.dart';
import '../pages/cart/providers/cart.dart';
import '../pages/product_detail/screens/product_detail_screen.dart';

import '../providers/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // ProductItem(String id, String title, String imageUrl);

  final String id;
  final String title;
  final String imageUrl;

  ProductItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    //  final _product = Provider.of<Product>(context, listen: false);
    // final cart = Provider.of<Cart>(context, listen: false);
    // final auth = Provider.of<AuthProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              // cart.addItem(_product.id, _product.title, _product.price);
              // Scaffold.of(context).hideCurrentSnackBar();
              // Scaffold.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text('Added item to cart!'),
              //     // duration: Duration(milliseconds: 400),
              //     backgroundColor: Colors.green,
              //     action: SnackBarAction(
              //       label: 'UNDO',
              //       onPressed: () {
              //         cart.removeSingleItem(_product.id);
              //       },
              //     ),
              //   ),
              // );
            },
          ),
        ),
        child: GestureDetector(
          child: Hero(
            tag: id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/original.png'),
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailPage.routeName, arguments: id);
          },
        ),
      ),
    );
  }
}
