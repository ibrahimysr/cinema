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

      log('Login API Response - Status: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('API response body boş veya null');
        }

        final dynamic decodedData;
        try {
          decodedData = json.decode(response.body);
        } catch (e) {
          log('JSON decode hatası: $e');
          throw Exception('API response geçerli bir JSON değil: ${response.body}');
        }

        if (decodedData is! Map<String, dynamic>) {
          throw Exception('API response beklenen formatta değil: $decodedData');
        }

        final Map<String, dynamic> data = decodedData;

        if (data['status'] != true) {
          throw Exception(data['message'] ?? 'Giriş başarısız');
        }

        final Map<String, dynamic> userData = data['data'] as Map<String, dynamic>;
        if (userData['access_token'] == null) {
          throw Exception('Token veya kullanıcı bilgileri eksik');
        }

        final Map<String, dynamic> authData = {
          'access_token': userData['access_token'],
          'user': {
            'id': userData['user_id'],
            'name': userData['user_name'],
            'email': userData['user_email'],
            'role_id': userData['user_role_id'],
            'cinema_id': userData['cinema_id'],
          },
        };

        await _saveAuthData(authData);
        return authData;
      } else {
        final dynamic errorData;
        try {
          errorData = json.decode(response.body);
        } catch (e) {
          log('Hata JSON decode hatası: $e');
          throw Exception('API hatası: ${response.statusCode} - ${response.body}');
        }
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
        if (response.body.isEmpty) {
          throw Exception('API response body boş veya null');
        }

        final dynamic decodedData;
        try {
          decodedData = json.decode(response.body);
        } catch (e) {
          log('JSON decode hatası: $e');
          throw Exception('API response geçerli bir JSON değil: ${response.body}');
        }

        if (decodedData is! Map<String, dynamic>) {
          throw Exception('API response beklenen formatta değil: $decodedData');
        }

        final Map<String, dynamic> data = decodedData;

        if (data['status'] != true) {
          throw Exception(data['message'] ?? 'Kayıt başarısız');
        }


        return await login(email, password);
      } else {
        final dynamic errorData;
        try {
          errorData = json.decode(response.body);
        } catch (e) {
          log('Hata JSON decode hatası: $e');
          throw Exception('API hatası: ${response.statusCode} - ${response.body}');
        }
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
      await _storageService.removeData(tokenKey);
      await _storageService.removeData(userKey);
    }
  }
}