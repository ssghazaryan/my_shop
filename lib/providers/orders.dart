import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../widgets/cart_item.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CardItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url = 'https://my-shop-a763e.firebaseio.com/orders.json';
    final response = await Dio().get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = response.data as Map<String, dynamic>;
    if(extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (items) => CardItem(
                  id: items['id'],
                  count: items['count'],
                  title: items['title'],
                  price: items['price'],
                ),
              )
              .toList()));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  addOrder(List<CardItem> cardProducts, double total) async {
    const url = 'https://my-shop-a763e.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    try {
      final response = await Dio().post(url, data: {
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cardProducts
            .map((e) => {
                  'id': e.id,
                  'title': e.title,
                  'price': e.price,
                  'count': e.count,
                })
            .toList(),
      });
      _orders.insert(
          0,
          OrderItem(
              amount: total,
              dateTime: timeStamp,
              id: response.data['name'],
              products: cardProducts));
      notifyListeners();
    } on DioError catch (error) {}
  }
}
