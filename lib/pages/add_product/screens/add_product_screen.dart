import 'package:MyShop/pages/add_product/providers/add_product_provider.dart';
import 'package:MyShop/pages/add_product/screens/barcode_screen.dart';
import 'package:MyShop/widgets/get_loader.dart';
import 'package:MyShop/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../globals/globals.dart' as globals;

class AddProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AddProductProvider(),
        )
      ],
      child: AddProductScreenChild(),
    );
  }
}

class AddProductScreenChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddProductProvider>(context);
    globals.globalContext = context;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Добавления товара'),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: provider.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldOutline(
                      onChange: (value) {
                        // provider.setName(value);
                      },
                      hint: 'Название',
                      function: (value) {
                        if (value.trim().isEmpty)
                          return 'Заполните поле';
                        else
                          return null;
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldOutline(
                            onChange: (value) {
                              // provider.setAddrees(value);
                            },
                            hint: 'Цена',
                            function: (value) {
                              if (value.trim().isEmpty)
                                return 'Заполните поле';
                              else
                                return null;
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextFieldOutline(
                            onChange: (value) {
                              // provider.setAddrees(value);
                            },
                            hint: 'Количество',
                            function: (value) {
                              if (value.trim().isEmpty)
                                return 'Заполните поле';
                              else
                                return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFieldOutline(
                      onChange: (value) {
                        // provider.setTypeOfMag(value);
                      },
                      hint: 'Тип магазина',
                      function: (value) {
                        if (value.trim().isEmpty)
                          return 'Заполните поле';
                        else
                          return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (MediaQuery.of(context).viewInsets.bottom == 0.0)
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: provider.barCode == ''
                    ? CupertinoButton(
                        color: Colors.green,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => ScanBarCode(),
                            ),
                          ).then((value) {
                            if (value != null) {
                              print(value);
                            }
                          });
                        },
                        child: Text(
                          'Отсканировать',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )
                    : CupertinoButton(
                        color: Colors.green,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (!provider.formKey.currentState.validate()) {
                            return;
                          } else {
                            // provider.saveMagazin();
                          }
                        },
                        child: Text(
                          'Создать',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
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
    );
  }
}
