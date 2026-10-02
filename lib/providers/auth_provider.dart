import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/models.dart';

class AuthProvider extends ChangeNotifier {
  static const _kLogin = 'is_logged_in_v1';
  static const _kName = 'user_name_v1';
  static const _kEmail = 'user_email_v1';

  bool _loggedIn = false;
  bool _ready = false;
  AppUser _user = const AppUser(
    name: 'Admin Kasir',
    email: 'admin@kasir.id',
    role: 'Kasir • Shift Pagi',
    storeName: 'Toko Berkah Jaya',
  );

  bool get isLoggedIn => _loggedIn;
  bool get ready => _ready;
  AppUser get user => _user;

  AuthProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _loggedIn = prefs.getBool(_kLogin) ?? false;
    final name = prefs.getString(_kName);
    final email = prefs.getString(_kEmail);
    if (name != null && email != null) {
      _user = AppUser(
        name: name,
        email: email,
        role: 'Kasir • Shift Pagi',
        storeName: 'Toko Berkah Jaya',
      );
    }
    _ready = true;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final ok = email.trim().toLowerCase() == 'admin@kasir.id' &&
        password == 'admin123';
    if (!ok) return false;
    _loggedIn = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLogin, true);
    await prefs.setString(_kName, _user.name);
    await prefs.setString(_kEmail, _user.email);
    return true;
  }

  Future<void> logout() async {
    _loggedIn = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLogin, false);
  }

  Future<void> updateProfile(String name, String storeName) async {
    _user = AppUser(
      name: name,
      email: _user.email,
      role: _user.role,
      storeName: storeName,
    );
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kName, name);
  }
}
