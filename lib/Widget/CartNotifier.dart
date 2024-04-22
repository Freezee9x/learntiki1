import 'package:flutter/material.dart';
import 'package:tikidemo/Screen/CartPage.dart';
import 'package:tikidemo/Model/Products.dart';

class CartNotifier extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  bool isProductInCart(Album product) {
    return _cartItems.any((item) => item.product.id == product.id);
  }

  void incrementItemQuantity(Album product) {
    for (var item in _cartItems) {
      if (item.product.id == product.id) {
        item.quantity++;
        break;
      }
    }
    notifyListeners();
  }

  void addToCart(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  double calculateTotal() {
    double total = 0;
    for (var item in _cartItems) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  void removeItem(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }
}
