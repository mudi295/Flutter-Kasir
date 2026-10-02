import 'package:flutter/material.dart';
import '../data/dummy/dummy_data.dart';
import '../data/models/models.dart';

class ProductProvider extends ChangeNotifier {
  String _query = '';
  String _categoryId = 'all';
  bool _onlyPromo = false;
  final Set<String> _favorites = {};

  String get query => _query;
  String get categoryId => _categoryId;
  bool get onlyPromo => _onlyPromo;

  List<Category> get categories => DummyData.categories;

  List<Product> get allProducts => DummyData.products
      .map((p) => p.copyWith(isFavorite: _favorites.contains(p.id)))
      .toList();

  List<Product> get filtered {
    final q = _query.trim().toLowerCase();
    return allProducts.where((p) {
      final matchCat = _categoryId == 'all' || p.categoryId == _categoryId;
      final matchQ = q.isEmpty || p.name.toLowerCase().contains(q);
      final matchPromo = !_onlyPromo || p.hasDiscount;
      return matchCat && matchQ && matchPromo;
    }).toList();
  }

  List<Product> get bestSellers {
    final list = List<Product>.from(allProducts)
      ..sort((a, b) => b.sold.compareTo(a.sold));
    return list.take(5).toList();
  }

  void setQuery(String v) {
    _query = v;
    notifyListeners();
  }

  void setCategory(String id) {
    _categoryId = id;
    notifyListeners();
  }

  void togglePromo(bool v) {
    _onlyPromo = v;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }

  void clearFilter() {
    _query = '';
    _categoryId = 'all';
    _onlyPromo = false;
    notifyListeners();
  }
}
