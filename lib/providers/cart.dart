import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem>? _items = {};
  late double _total;

  Map<String, CartItem> get items {
    return {...?_items};
  }

  int get itemCount {
    var totalItems = 0;
    _items?.forEach((key, value) {totalItems += value.quantity;});
    return totalItems;
  }

  double get totalAmount {
    var total = 0.0;
    _items!.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  double get total {
    var total = 0.0;
    _items!.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    _total = total;
    notifyListeners();
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items!.containsKey(productId)) {
      _items!.update(
        productId,
            (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity + 1,
            price: existingCartItem.price),
      );
    } else {
      _items!.putIfAbsent(
          productId,
              () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price,
          ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items!.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    print('CLEAR SUCCESS');
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items!.containsKey(productId)) {
      return;
    }
    if (_items![productId]!.quantity > 1) {
      _items!.update(
        productId,
            (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity - 1,
            price: existingCartItem.price),
      );
    } else {
      _items!.remove(productId);
    }
    notifyListeners();
  }
}
