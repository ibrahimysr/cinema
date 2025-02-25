import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../base/base_service.dart';
import '../storage/storage_service.dart';

abstract class AuthServiceInterface {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(String name, String email, String password, String passwordConfirm);
  Future<void> logout();
  Future<String?> getToken();
}

class AuthService extends BaseService implements AuthServiceInterface {
  static const String tokenKey = 'access_token';
  static const String userKey = 'user_data';
  
  final StorageService _storageService;
  final http.Client _client;
  
  AuthService({
    required StorageService storageService,
    http.Client? client,
  }) : _storageService = storageService,
       _client = client ?? http.Client();
  
  @override
  http.Client get httpClient => _client;
  
  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await httpClient.post(
        buildUrl('login'),
        headers: headers,
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
      log('Login hatası: $e');
      throw Exception('Giriş sırasında hata oluştu: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> register(String name, String email, String password, String passwordConfirm) async {
    try {
      log('Register isteği gönderiliyor:');
      log('URL: ${buildUrl('register')}');
      
      final response = await httpClient.post(
        buildUrl('register'),
        headers: headers,
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
    await _storageService.saveData(tokenKey, data['access_token']);
    await _storageService.saveData(userKey, json.encode(data['user']));
  }

  @override
  Future<String?> getToken() async {
    return await _storageService.getData<String>(tokenKey);
  }

  @override
  Future<void> logout() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Token bulunamadı');
      }

      final response = await httpClient.post(
        buildUrl('logout'),
        headers: getAuthHeaders(token),
      );

      if (response.statusCode != 200) {
        log('Logout API Hatası: ${response.body}');
      }
    } catch (e) {
      log('Logout sırasında hata oluştu: $e');
    } finally {
      // API çağrısı başarısız olsa bile local verileri temizle
      await _storageService.removeData(tokenKey);
      await _storageService.removeData(userKey);
    }
  }
} 