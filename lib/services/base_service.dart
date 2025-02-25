import 'package:http/http.dart' as http;

abstract class BaseService {
  static const String baseUrl = 'http://10.10.27.29:8000/api';
  
  // HTTP istemcisi için getter
  http.Client get httpClient;
  
  // API endpoint'lerini oluşturmak için yardımcı metod
  Uri buildUrl(String path) {
    return Uri.parse('$baseUrl/$path');
  }
  
  // Standart HTTP başlıkları
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Token ile birlikte HTTP başlıkları
  Map<String, String> getAuthHeaders(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
} 