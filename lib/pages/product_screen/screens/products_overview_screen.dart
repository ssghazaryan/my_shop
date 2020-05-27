import '../../../pages/cart/providers/cart.dart';
import '../../../pages/cart/screens/cart_screen.dart';
import '../../../providers/products_provider.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/badge.dart';
import '../../../widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview-screen'; 
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isInit = true;
  bool _isLoaading = true;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((value) =>
    // Provider.of<Products>(context).getProductsFromDatabase());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Products>(context).getProductsFromDatabase().then((_) {
        setState(() {
          _isLoaading = false;
        });
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue.index == 0)
                  _showOnlyFavorites = true;
                else
                  _showOnlyFavorites = false;
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
            ],
          ),
          Consumer<Cart>(
            builder: (BuildContext _, _cartData, Widget ch) {
              return Badge(child: ch, value: _cartData.itemCount.toString());
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoaading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {
               return Provider.of<Products>(context,listen: false)
                    .getProductsFromDatabase()
                    .then((_) {
                  setState(() {
                    _isLoaading = false;
                  });
                });
              },
              child: SafeArea(
                child: Container(
                  child: ProductGrid(_showOnlyFavorites),
                ),
              ),
            ),
    );
  }
}
