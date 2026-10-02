import 'package:flutter/material.dart';
import '../data/models/models.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();
  int get count => _items.values.fold(0, (a, b) => a + b.qty);
  double get subtotal => _items.values.fold(0, (a, b) => a + b.subtotal);
  bool get isEmpty => _items.isEmpty;

  void add(Product product, {int qty = 1}) {
    final existing = _items[product.id];
    if (existing == null) {
      _items[product.id] = CartItem(product: product, qty: qty);
    } else {
      _items[product.id] = existing.copyWith(qty: existing.qty + qty);
    }
    notifyListeners();
  }

  void setQty(String productId, int qty) {
    if (qty <= 0) {
      _items.remove(productId);
    } else {
      final e = _items[productId];
      if (e != null) _items[productId] = e.copyWith(qty: qty);
    }
    notifyListeners();
  }

  void remove(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
