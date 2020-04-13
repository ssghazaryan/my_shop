import 'package:MyShop/providers/products_provider.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/edit_product_screen.dart';
import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  UserProductItem({this.id, this.title, this.imageUrl, this.description, this.price});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 150,
        child: Row(
          children: [
             IconButton(
              icon: Icon(Icons.content_copy,size: 18,),
              onPressed: () {
                  Provider.of<Products>(context, listen: false).addProduct(
                    Product(
                      description: description,
                      title: '$title + copy',
                      imageUrl: imageUrl,
                      price: price, 
                      id: null,
                    )
                  );
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .delateProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Deleting failed!', textAlign: TextAlign.center,),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
