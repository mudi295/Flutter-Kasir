import 'package:flutter/material.dart';
import '../models/models.dart';

class DummyData {
  static const categories = [
    Category(id: 'all', name: 'Semua', icon: Icons.grid_view_rounded, color: Color(0xFF4F46E5)),
    Category(id: 'makanan', name: 'Makanan', icon: Icons.fastfood_rounded, color: Color(0xFFF59E0B)),
    Category(id: 'minuman', name: 'Minuman', icon: Icons.local_cafe_rounded, color: Color(0xFF0EA5E9)),
    Category(id: 'snack', name: 'Snack', icon: Icons.cookie_rounded, color: Color(0xFFEC4899)),
    Category(id: 'atk', name: 'ATK', icon: Icons.edit_note_rounded, color: Color(0xFF10B981)),
    Category(id: 'rumah', name: 'Rumah', icon: Icons.home_rounded, color: Color(0xFF8B5CF6)),
  ];

  static const products = [
    Product(id: 'p1', name: 'Nasi Goreng Spesial', categoryId: 'makanan', price: 18000, discountPrice: 15000, stock: 24, unit: 'porsi', icon: Icons.rice_bowl_rounded, color: Color(0xFFF59E0B), rating: 4.8, sold: 320),
    Product(id: 'p2', name: 'Ayam Geprek Sambal', categoryId: 'makanan', price: 15000, stock: 30, unit: 'porsi', icon: Icons.set_meal_rounded, color: Color(0xFFEF4444), rating: 4.7, sold: 280),
    Product(id: 'p3', name: 'Mie Ayam Bakso', categoryId: 'makanan', price: 13000, stock: 20, unit: 'porsi', icon: Icons.ramen_dining_rounded, color: Color(0xFFF97316), rating: 4.6, sold: 210),
    Product(id: 'p4', name: 'Soto Ayam Lamongan', categoryId: 'makanan', price: 14000, stock: 18, unit: 'porsi', icon: Icons.soup_kitchen_rounded, color: Color(0xFFEAB308), rating: 4.7, sold: 190),
    Product(id: 'p5', name: 'Es Teh Manis', categoryId: 'minuman', price: 5000, stock: 100, unit: 'gelas', icon: Icons.local_drink_rounded, color: Color(0xFF0EA5E9), rating: 4.5, sold: 520),
    Product(id: 'p6', name: 'Kopi Susu Gula Aren', categoryId: 'minuman', price: 12000, discountPrice: 10000, stock: 45, unit: 'cup', icon: Icons.coffee_rounded, color: Color(0xFF92400E), rating: 4.9, sold: 410),
    Product(id: 'p7', name: 'Matcha Latte', categoryId: 'minuman', price: 15000, stock: 32, unit: 'cup', icon: Icons.emoji_food_beverage_rounded, color: Color(0xFF16A34A), rating: 4.6, sold: 150),
    Product(id: 'p8', name: 'Jus Alpukat', categoryId: 'minuman', price: 13000, stock: 25, unit: 'gelas', icon: Icons.blender_rounded, color: Color(0xFF65A30D), rating: 4.5, sold: 130),
    Product(id: 'p9', name: 'Keripik Kentang 250g', categoryId: 'snack', price: 22000, stock: 40, unit: 'pcs', icon: Icons.cookie_rounded, color: Color(0xFFEC4899), rating: 4.4, sold: 180),
    Product(id: 'p10', name: 'Roti Coklat Lumer', categoryId: 'snack', price: 10000, discountPrice: 8000, stock: 50, unit: 'pcs', icon: Icons.bakery_dining_rounded, color: Color(0xFFB45309), rating: 4.7, sold: 260),
    Product(id: 'p11', name: 'Buku Tulis A5 (isi 3)', categoryId: 'atk', price: 25000, stock: 60, unit: 'pak', icon: Icons.book_rounded, color: Color(0xFF10B981), rating: 4.3, sold: 90),
    Product(id: 'p12', name: 'Pulpen Gel Hitam', categoryId: 'atk', price: 5000, stock: 200, unit: 'pcs', icon: Icons.edit_rounded, color: Color(0xFF334155), rating: 4.6, sold: 340),
    Product(id: 'p13', name: 'Sabun Cuci Piring', categoryId: 'rumah', price: 9000, stock: 70, unit: 'pcs', icon: Icons.cleaning_services_rounded, color: Color(0xFF8B5CF6), rating: 4.4, sold: 110),
    Product(id: 'p14', name: 'Tisu Multipurpose', categoryId: 'rumah', price: 16000, discountPrice: 13500, stock: 55, unit: 'pak', icon: Icons.layers_rounded, color: Color(0xFF0284C7), rating: 4.5, sold: 140),
  ];

  static List<AppTransaction> seedTransactions() {
    final now = DateTime.now();
    return [
      AppTransaction(
        id: 'TRX-2026-0007',
        date: now.subtract(const Duration(hours: 1)),
        items: const [
          TransactionItem(productId: 'p6', productName: 'Kopi Susu Gula Aren', price: 10000, qty: 2),
          TransactionItem(productId: 'p10', productName: 'Roti Coklat Lumer', price: 8000, qty: 2),
        ],
        subtotal: 36000,
        discount: 0,
        tax: 3600,
        total: 39600,
        paymentMethod: 'QRIS',
        cashReceived: 39600,
        cashier: 'Admin Kasir',
        customerName: 'Dinda',
      ),
      AppTransaction(
        id: 'TRX-2026-0006',
        date: now.subtract(const Duration(hours: 3)),
        items: const [
          TransactionItem(productId: 'p1', productName: 'Nasi Goreng Spesial', price: 15000, qty: 1),
          TransactionItem(productId: 'p5', productName: 'Es Teh Manis', price: 5000, qty: 2),
        ],
        subtotal: 25000,
        discount: 2000,
        tax: 2300,
        total: 25300,
        paymentMethod: 'Tunai',
        cashReceived: 30000,
        cashier: 'Admin Kasir',
      ),
      AppTransaction(
        id: 'TRX-2026-0005',
        date: now.subtract(const Duration(days: 1, hours: 2)),
        items: const [
          TransactionItem(productId: 'p2', productName: 'Ayam Geprek Sambal', price: 15000, qty: 3),
        ],
        subtotal: 45000,
        discount: 0,
        tax: 4500,
        total: 49500,
        paymentMethod: 'Transfer',
        cashReceived: 49500,
        cashier: 'Admin Kasir',
        customerName: 'Budi',
      ),
    ];
  }
}
