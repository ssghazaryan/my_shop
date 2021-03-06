import '../models/rest_exception.dart';
import 'package:dio/dio.dart';

import '../providers/product.dart';
import 'package:flutter/material.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // var _showFavoritesOnly = false;
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavoritesOnly)
    //  return _items.where((element) => element.isFavorite).toList();
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String productId) {
    return items.firstWhere((element) => productId == element.id);
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://my-shop-a763e.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await Dio().post(url, data: {
        'title': product.title,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'description': product.description,
        'creatorId' : userId
        // 'isFavorite': product.isFavorite,
      });
      final newProduct = Product(
          id: response.data['name'],
          title: product.title,
          price: product.price,
          imageUrl: product.imageUrl,
          description: product.description);
      _items.add(newProduct);
      notifyListeners();
    }on DioError catch (error) {
      print(error.response.data);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final index = _items.indexWhere((element) => id == element.id);
    if (index >= 0) {
      final url = 'https://my-shop-a763e.firebaseio.com/products/$id.json?auth=$authToken';
      try {
        await Dio().patch(url, data: {
          'title': newProduct.title,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
          'description': newProduct.description,
        });
        _items[index] = newProduct;
      } catch (error) {
        print(error);
      }
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> delateProduct(String id) async {
    final url = 'https://my-shop-a763e.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((element) => id == element.id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    await Dio().delete(url).catchError((error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw RestException('Could not delete product.');
    });
    existingProduct = null;
  }

  Future<void> getProductsFromDatabase([bool filerByUser = false]) async {
    print('her $filerByUser');
    final filterString = filerByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
     var url = 'https://my-shop-a763e.firebaseio.com/products.json?auth=$authToken&$filerByUser';
    try {
      final response = await Dio().get(url);
      final data = response.data as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      print(response.statusCode);
      if (data == null) {
        return;
      }
      url = 'https://my-shop-a763e.firebaseio.com/userFavorites/$userId.json?auth=$authToken';

      final favoriteResponse = await Dio().get(url);
      final favoriteData = favoriteResponse.data;

      data.forEach((prodId, prod) {
        loadedProduct.add(Product(
          description: prod["description"],
          id: prodId,
          imageUrl: prod["imageUrl"],
          price: prod["price"],
          title: prod["title"],
          isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
        _items = loadedProduct;
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
}
