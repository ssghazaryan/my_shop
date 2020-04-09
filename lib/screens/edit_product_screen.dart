import 'package:MyShop/providers/product.dart';
import 'package:MyShop/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routName = '/edit-product-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocuseNode = FocusNode();
  final _descriptionFocuseNode = FocusNode();
  final _imageUrlFocuseNode = FocusNode();
  final _imageController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');

  @override
  void dispose() {
    _imageUrlFocuseNode.removeListener(_updateImageUrl);
    _priceFocuseNode.dispose();
    _imageUrlFocuseNode.dispose();
    _descriptionFocuseNode.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocuseNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocuseNode.hasFocus) {
      if ((!_imageController.text.startsWith('http') &&
              !_imageController.text.startsWith('https')) ||
          (!_imageController.text.endsWith('.png') &&
              !_imageController.text.endsWith('.jpg') &&
              !_imageController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // autovalidate: true,
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_priceFocuseNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: value,
                    id: _editedProduct.id,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                  );
                },
                validator: (value) {
                  if (value.isEmpty)
                    return 'Please provide a value.';
                  else
                    return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                focusNode: _priceFocuseNode,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocuseNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    id: _editedProduct.id,
                    imageUrl: _editedProduct.imageUrl,
                    price: double.parse(value),
                    description: _editedProduct.description,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) return 'Please enter a price.';
                  if (double.tryParse(value) == null)
                    return 'Please enter a valid number';
                  if (double.parse(value) <= 0)
                    return 'Please enter a number greather then zero';
                  return null;
                },
              ),
              TextFormField(
                focusNode: _descriptionFocuseNode,
                decoration: InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    id: _editedProduct.id,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                    description: value,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) return 'Please enter a Description.';
                  if (value.length < 10)
                    return 'Should be at least 10 characters long.';
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: _imageController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      maxLines: 3,
                      focusNode: _imageUrlFocuseNode,
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) => _saveForm(),
                      controller: _imageController,
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          id: _editedProduct.id,
                          imageUrl: value,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter an Image URL.';
                        if (!value.startsWith('http') &&
                            !value.startsWith('https'))
                          return 'Please enter a valid URL';
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg'))
                          return 'Please enter a valid Image URL';
                        return null;
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
