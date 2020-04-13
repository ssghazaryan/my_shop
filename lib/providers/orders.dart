import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  final String authToken;
  List<OrderItem> _orders = [];
  final String userId;

  List<OrderItem> get orders {
    return [..._orders];
  }

  Orders(this.authToken,this.userId, this._orders);

  Future<void> fetchAndSetOrders() async {
    final url = 'https://my-shop-a763e.firebaseio.com/orders/$userId.json?auth=$authToken';
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
    final url = 'https://my-shop-a763e.firebaseio.com/orders/$userId.json?auth=$authToken';
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
    } on DioError catch (error) {
      print(error);
    }
  }
}
