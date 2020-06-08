import 'dart:io';

import 'package:MyShop/pages/add_product/providers/add_product_provider.dart';
import 'package:MyShop/pages/add_product/screens/barcode_screen.dart';
import 'package:MyShop/widgets/get_loader.dart';
import 'package:MyShop/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../globals/globals.dart' as globals;
import '../../../globals/colors.dart' as col;

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
        actions: [
          IconButton(
            icon: Icon(MaterialCommunityIcons.barcode_scan),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ScanBarCode(),
                ),
              ).then((value) {
                if (value != null) {
                  provider.getProduct(value);
                }
              });
            },
          ),
          SizedBox(
            width: 8,
          )
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: provider.isLoading
                  ? SizedBox()
                  : provider.controllerBarCode.text == ''
                      ? Center(
                          child: CupertinoButton(
                            color: Colors.green,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ScanBarCode(),
                                ),
                              ).then((value) {
                                if (value != null) {
                                  provider.getProduct(value);
                                }
                              });
                            },
                            child: Text(
                              'Отсканировать',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Form(
                          key: provider.formKey,
                          child: ListView(
                            children: [
                              provider.controllerProductImageUrl.text != ''
                                  ? Image.network(
                                      provider.controllerProductImageUrl.text,
                                      height: 250,
                                      fit: BoxFit.fitHeight,
                                    )
                                  : Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              'Товар не найден, добавьте данные для создания'),
                                        ),
                                        provider.imagePath != ''
                                            ? Stack(
                                                children: [
                                                  InkWell(
                                                    onTap: () => provider.uploadFile(),
                                                    child: Image.asset(
                                                      provider.imagePath,
                                                      height: 250,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                  Positioned(
                                                      right: 0,
                                                      top: 0,
                                                      child: IconButton(
                                                        icon: Icon(Icons.close),
                                                        onPressed: () {
                                                          provider.setImagePath(
                                                              '', null);
                                                        },
                                                      ))
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: FlatButton(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      onPressed: () {
                                                        ImagePicker.pickImage(
                                                          imageQuality: 85,
                                                          source: ImageSource
                                                              .gallery,
                                                        ).then((value) {
                                                          if (value != null) {
                                                            provider
                                                                .setImagePath(
                                                                    value.path,
                                                                    value);
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 100,
                                                        width: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                              width: 1,
                                                              color: col.light),
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                              Icons.photo,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: FlatButton(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      onPressed: () {
                                                        ImagePicker.pickImage(
                                                          imageQuality: 50,
                                                          source: ImageSource
                                                              .camera,
                                                        ).then((value) {
                                                          if (value != null) {
                                                            provider
                                                                .setImagePath(
                                                                    value.path,
                                                                    value);
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 100,
                                                        width: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                              width: 1,
                                                              color: col.light),
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                              Icons.camera_alt,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFieldOutline(
                                controller: provider.controllerProductName,
                                onChange: (value) {
                                  provider.setName(value);
                                },
                                hint: 'Название товара',
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
                                      controller:
                                          provider.controllerProductPrice,
                                      onChange: (value) {
                                        provider.setPrice(value);
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
                                      controller:
                                          provider.controllerProductWeight,
                                      onChange: (value) {
                                        provider.setWeight(value);
                                      },
                                      hint: 'Вес',
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
                                 controller: provider.controllerProductCount,
                                onChange: (value) {
                                   provider.setCount(value);
                                },
                                hint: 'Количество',
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
                                controller: provider.controllerBarCode,
                                onChange: (value) {
                                  provider.setBarCode(value);
                                },
                                hint: 'BarCode',
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
            if (provider.controllerBarCode.text != '')
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
                        provider.sendNewProduct();
                      }
                    },
                    child: Text(
                      'Создать',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
