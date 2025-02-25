import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'http://10.10.27.29:8000/api';  // Android Emulator için localhost
  static const String tokenBoxName = 'auth_box';
  static const String tokenKey = 'access_token';
  static const String userKey = 'user_data';

  Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox(tokenBoxName);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        await _saveAuthData(data);
        return data;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Giriş başarısız');
      }
    } catch (e) {
      throw Exception('Giriş sırasında hata oluştu: $e');
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password, String passwordConfirm) async {
    try {
      log('Register isteği gönderiliyor:');
      log('URL: $baseUrl/register');
      log('Body: ${jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirm,
        'role_id': 1
      })}');

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirm,
          'role_id': 1
        }),
      );

      log('Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Kayıt başarılı olduktan sonra otomatik login yap
        return await login(email, password);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? errorData.toString() ?? 'Kayıt başarısız');
      }
    } catch (e) {
      log('Hata detayı: $e');
      throw Exception('Kayıt sırasında hata oluştu: $e');
    }
  }

  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    final box = await Hive.openBox(tokenBoxName);
    await box.put(tokenKey, data['access_token']);
    await box.put(userKey, json.encode(data['user']));
  }

  Future<String?> getToken() async {
    final box = await Hive.openBox(tokenBoxName);
    return box.get(tokenKey);
  }

  Future<UserModel?> getUser() async {
    final box = await Hive.openBox(tokenBoxName);
    final userStr = box.get(userKey);
    if (userStr != null) {
      return UserModel.fromJson(json.decode(userStr));
    }
    return null;
  }

  Future<void> logout() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Token bulunamadı');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        log('Logout API Hatası: ${response.body}');
      }
    } catch (e) {
      log('Logout sırasında hata oluştu: $e');
    } finally {
      // API çağrısı başarısız olsa bile local verileri temizle
      final box = await Hive.openBox(tokenBoxName);
      await box.delete(tokenKey);
      await box.delete(userKey);
    }
  }

  Future<UserModel> getProfile() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token bulunamadı');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final user = UserModel.fromJson(data);
        // Kullanıcı bilgilerini güncelle
        final box = await Hive.openBox(tokenBoxName);
        await box.put(userKey, json.encode(data));
        return user;
      } else {
        throw Exception('Profil bilgileri alınamadı: ${response.body}');
      }
    } catch (e) {
      throw Exception('Profil bilgileri alınırken hata oluştu: $e');
    }
  }
} 