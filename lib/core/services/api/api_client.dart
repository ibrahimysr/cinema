import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../base/base_service.dart';

/// API isteklerini yönetmek için kullanılan sınıf
class ApiClient {
  final http.Client _client;
  static const String baseUrl = BaseService.baseUrl;
  
  ApiClient({http.Client? client}) : _client = client ?? http.Client();
  
  // Standart HTTP başlıkları
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Token ile birlikte HTTP başlıkları
  Map<String, String> _getAuthHeaders(String token) => {
    ..._headers,
    'Authorization': 'Bearer $token',
  };
  
  // API endpoint'lerini oluşturmak için yardımcı metod
  Uri _buildUrl(String path) {
    return Uri.parse('$baseUrl/$path');
  }
  
  /// GET isteği gönderir
  Future<Map<String, dynamic>> get(String path, {String? token}) async {
    try {
      final response = await _client.get(
        _buildUrl(path),
        headers: token != null ? _getAuthHeaders(token) : _headers,
      );
      
      return _handleResponse(response);
    } catch (e) {
      log('GET isteği sırasında hata: $e');
      throw Exception('İstek sırasında hata oluştu: $e');
    }
  }
  
  /// POST isteği gönderir
  Future<Map<String, dynamic>> post(
    String path, 
    {Map<String, dynamic>? body, String? token}
  ) async {
    try {
      final response = await _client.post(
        _buildUrl(path),
        headers: token != null ? _getAuthHeaders(token) : _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      
      return _handleResponse(response);
    } catch (e) {
      log('POST isteği sırasında hata: $e');
      throw Exception('İstek sırasında hata oluştu: $e');
    }
  }
  
  /// PUT isteği gönderir
  Future<Map<String, dynamic>> put(
    String path, 
    {Map<String, dynamic>? body, String? token}
  ) async {
    try {
      final response = await _client.put(
        _buildUrl(path),
        headers: token != null ? _getAuthHeaders(token) : _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      
      return _handleResponse(response);
    } catch (e) {
      log('PUT isteği sırasında hata: $e');
      throw Exception('İstek sırasında hata oluştu: $e');
    }
  }
  
  /// DELETE isteği gönderir
  Future<Map<String, dynamic>> delete(String path, {String? token}) async {
    try {
      final response = await _client.delete(
        _buildUrl(path),
        headers: token != null ? _getAuthHeaders(token) : _headers,
      );
      
      return _handleResponse(response);
    } catch (e) {
      log('DELETE isteği sırasında hata: $e');
      throw Exception('İstek sırasında hata oluştu: $e');
    }
  }
  
  /// HTTP yanıtını işler
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body);
    } else {
      log('API Hatası: ${response.statusCode} - ${response.body}');
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'API isteği başarısız oldu');
    }
  }
  
  /// İstemciyi kapatır
  void dispose() {
    _client.close();
  }
} 