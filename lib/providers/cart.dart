import 'package:flutter/material.dart';

class CardItem {
  final String id;
  final String title;
  final int count;
  final double price;

  CardItem({
    @required this.id,
    @required this.title,
    this.count,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CardItem> _items = {};

  Map<String, CardItem> get items {
    return {..._items};
  }

  int get itemCount {
    int total = 0;
    _items.forEach((key, value) {
      total += value.count;
    });
    return total;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.count * value.price;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CardItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          count: existingItem.count + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
          productId,
          () => CardItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              count: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear(){
    _items = {};
    notifyListeners();
  }
}
