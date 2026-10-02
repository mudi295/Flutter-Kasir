import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class Product {
  final String id;
  final String name;
  final String categoryId;
  final double price;
  final double? discountPrice;
  final int stock;
  final String unit;
  final IconData icon;
  final Color color;
  final double rating;
  final int sold;
  final bool isFavorite;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    this.discountPrice,
    required this.stock,
    required this.unit,
    required this.icon,
    required this.color,
    this.rating = 4.5,
    this.sold = 0,
    this.isFavorite = false,
  });

  double get effectivePrice => discountPrice ?? price;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  Product copyWith({bool? isFavorite, int? stock}) {
    return Product(
      id: id,
      name: name,
      categoryId: categoryId,
      price: price,
      discountPrice: discountPrice,
      stock: stock ?? this.stock,
      unit: unit,
      icon: icon,
      color: color,
      rating: rating,
      sold: sold,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class CartItem {
  final Product product;
  final int qty;
  final String? note;

  const CartItem({required this.product, required this.qty, this.note});

  double get subtotal => product.effectivePrice * qty;

  CartItem copyWith({int? qty, String? note}) {
    return CartItem(
      product: product,
      qty: qty ?? this.qty,
      note: note ?? this.note,
    );
  }
}

class TransactionItem {
  final String productId;
  final String productName;
  final double price;
  final int qty;

  const TransactionItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.qty,
  });

  double get subtotal => price * qty;

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'productName': productName,
        'price': price,
        'qty': qty,
      };

  factory TransactionItem.fromMap(Map<String, dynamic> m) => TransactionItem(
        productId: m['productId'] as String,
        productName: m['productName'] as String,
        price: (m['price'] as num).toDouble(),
        qty: m['qty'] as int,
      );
}

class AppTransaction {
  final String id;
  final DateTime date;
  final List<TransactionItem> items;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final String paymentMethod;
  final double cashReceived;
  final String? customerName;
  final String cashier;

  const AppTransaction({
    required this.id,
    required this.date,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.cashReceived,
    this.customerName,
    required this.cashier,
  });

  double get change => cashReceived - total;
  int get totalQty => items.fold(0, (a, b) => a + b.qty);
}

class AppUser {
  final String name;
  final String email;
  final String role;
  final String storeName;

  const AppUser({
    required this.name,
    required this.email,
    required this.role,
    required this.storeName,
  });
}
