import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  String? _token;
  bool _isLoading = false;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _token != null;

  Future<void> init() async {
    _token = await _authService.getToken();
    if (_token != null) {
      await refreshProfile();
    }
  }

  Future<void> refreshProfile() async {
    try {
      _user = await _authService.getProfile();
      notifyListeners();
    } catch (e) {
      // Profil bilgileri alınamazsa local'den almayı dene
      _user = await _authService.getUser();
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);
      _token = response['access_token'];
      _user = UserModel.fromJson(response['user']);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password, String passwordConfirm) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.register(name, email, password, passwordConfirm);
      _token = response['access_token'];
      _user = UserModel.fromJson(response['user']);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _token = null;
      _user = null;
    } catch (e) {
      print('Logout sırasında hata oluştu: $e');
      // Hata olsa bile local verileri temizle
      _token = null;
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 