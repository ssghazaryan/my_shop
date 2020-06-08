import 'package:MyShop/pages/shop/providers/shop_provider.dart';
import 'package:MyShop/widgets/get_loader.dart';
import 'package:MyShop/widgets/product_item.dart';

import '../../../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../globals/globals.dart' as globals;

class ProductsOverviewScreen extends StatelessWidget {
  static const routeName = '/product-overview-screen';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ShopProvider(),
        ),
      ],
      child: ProductsOverviewScreenChild(),
    );
  }
}

class ProductsOverviewScreenChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopProvider>(context);
    globals.globalContext = context;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Товары'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => provider.getData(),
        child: Stack(
          children: [
            if (!provider.isLoading)
              SafeArea(
                child: Container(
                  child: Column(
                    children: [
                      provider.products.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Нет товаров в магазине'),
                              ),
                            )
                          : Expanded(
                              child: GridView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: provider.products.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (btx, index) {
                                return ChangeNotifierProvider.value(
                                  value: provider,
                                  child: ProductItem(
                                    title: provider.products[index].name,
                                    id: provider.products[index].barcode,
                                    imageUrl: provider.products[index].image,
                                  ),
                                );
                              },
                            ))
                    ],
                  ),
                ),
              ),
            if (provider.isLoading)
              PreLoader(
                color: true,
                marigin: true,
              )
          ],
        ),
      ),
    );
  }
}
