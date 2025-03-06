import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../core/services/index.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthServiceInterface _authService;
  final UserServiceInterface _userService;
  
  UserModel? _user;
  String? _token;
  bool _isLoading = false;

  AuthViewModel({
    AuthServiceInterface? authService,
    UserServiceInterface? userService,
  }) : _authService = authService ?? ServiceProvider().authService,
       _userService = userService ?? ServiceProvider().userService;

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
      _user = await _userService.getProfile(_token);
      notifyListeners();
    } catch (e) {
      _user = await _userService.getUser();
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);
      _token = response['access_token'];
      await refreshProfile(); 
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
      await refreshProfile(); 
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
      log('Logout sırasında hata oluştu: $e');
      _token = null;
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}