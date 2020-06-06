import 'package:MyShop/pages/add_product/screens/add_product_screen.dart';
import 'package:MyShop/pages/warehouse/providers/ware_house_provider.dart';

import '../../../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../globals/globals.dart' as globals;

class WareHouse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => WareHouseProvider(),
        )
      ],
      child: WareHouseChild(),
    );
  }
}

class WareHouseChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WareHouseProvider>(context);
    globals.globalContext = context;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddProductScreen()));
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Склад'),
      ),
      drawer: AppDrawer(),
      body: provider.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {
                // return Provider.of<Products>(context, listen: false)
                //     .getProductsFromDatabase()
                //     .then((_) {
                //   setState(() {
                //     _isLoaading = false;
                //   });
                // });
              },
              child: SafeArea(
                child: Container(
                  child: Container(),
                ),
              ),
            ),
    );
  }
}
