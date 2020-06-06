import 'package:MyShop/pages/registr_shops/providers/shops_provider.dart';
import 'package:MyShop/widgets/get_loader.dart';
import 'package:MyShop/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddShopScreen extends StatelessWidget {
  static const routeName = '/shops-create';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopsRegistrProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cоздать магазин'),
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
                        provider.setName(value);
                      },
                      hint: 'Название магазина',
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
                    TextFieldOutline(
                      onChange: (value) {
                        provider.setAddrees(value);
                      },
                      hint: 'Адресс магазина',
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
                    TextFieldOutline(
                      onChange: (value) {
                        provider.setTypeOfMag(value);
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
                child: CupertinoButton(
                  color: Colors.green,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (!provider.formKey.currentState.validate()) {
                      return;
                    } else {
                      provider.saveMagazin();
                    }
                  },
                  child: Text(
                    'Создать',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
