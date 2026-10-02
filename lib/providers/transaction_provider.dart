import 'package:flutter/material.dart';
import '../data/dummy/dummy_data.dart';
import '../data/models/models.dart';

class TransactionProvider extends ChangeNotifier {
  final List<AppTransaction> _transactions = [...DummyData.seedTransactions()];
  String _query = '';

  String get query => _query;

  List<AppTransaction> get transactions {
    final q = _query.trim().toLowerCase();
    final list = List<AppTransaction>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    if (q.isEmpty) return list;
    return list
        .where((t) =>
            t.id.toLowerCase().contains(q) ||
            (t.customerName ?? '').toLowerCase().contains(q) ||
            t.paymentMethod.toLowerCase().contains(q))
        .toList();
  }

  double get todayRevenue {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
            t.date.year == now.year &&
            t.date.month == now.month &&
            t.date.day == now.day)
        .fold(0.0, (a, b) => a + b.total);
  }

  int get todayCount {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
            t.date.year == now.year &&
            t.date.month == now.month &&
            t.date.day == now.day)
        .length;
  }

  double get totalRevenue =>
      _transactions.fold(0.0, (a, b) => a + b.total);

  void setQuery(String v) {
    _query = v;
    notifyListeners();
  }

  AppTransaction? byId(String id) {
    try {
      return _transactions.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  AppTransaction checkout({
    required List<CartItem> cartItems,
    required String paymentMethod,
    required double cashReceived,
    required String cashier,
    String? customerName,
    double discount = 0,
    double taxRate = 0.1,
  }) {
    final items = cartItems
        .map((c) => TransactionItem(
              productId: c.product.id,
              productName: c.product.name,
              price: c.product.effectivePrice,
              qty: c.qty,
            ))
        .toList();
    final subtotal = items.fold(0.0, (a, b) => a + b.subtotal);
    final tax = (subtotal - discount) * taxRate;
    final total = subtotal - discount + tax;
    final trx = AppTransaction(
      id:
          'TRX-2026-${(_transactions.length + 8).toString().padLeft(4, '0')}',
      date: DateTime.now(),
      items: items,
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      total: total,
      paymentMethod: paymentMethod,
      cashReceived: cashReceived,
      customerName: customerName?.isEmpty == true ? null : customerName,
      cashier: cashier,
    );
    _transactions.add(trx);
    notifyListeners();
    return trx;
  }
}
