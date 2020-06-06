import 'package:MyShop/pages/cassa/providers/casa_provider.dart';

import '../../../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../globals/globals.dart' as globals;

class CassaScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => CasaProvider(),
        )
      ],
      child: CassaScreenScreenChild(),
    );
  }
}

class CassaScreenScreenChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CasaProvider>(context);
    globals.globalContext = context;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Касса'),
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
