import 'package:http/http.dart' as http;
import 'api/api_client.dart';
import 'auth/auth_service.dart';
import 'storage/storage_service.dart';
import 'user/user_service.dart';

/// Uygulama genelinde kullanılacak servisleri sağlayan sınıf.
/// Dependency Injection için kullanılır.
class ServiceProvider {
  static final ServiceProvider _instance = ServiceProvider._internal();
  
  factory ServiceProvider() {
    return _instance;
  }
  
  ServiceProvider._internal();
  
  // Servisler
  late final StorageService storageService;
  late final AuthServiceInterface authService;
  late final UserServiceInterface userService;
  late final ApiClient apiClient;
  
  /// Servisleri başlatır
  Future<void> initialize() async {
    // HTTP istemcisi
    final client = http.Client();
    
    // API istemcisi
    apiClient = ApiClient(client: client);
    
    // Storage servisi
    storageService = HiveStorageService();
    await storageService.init();
    
    // Auth servisi
    authService = AuthService(
      storageService: storageService,
      client: client,
    );
    
    // User servisi
    userService = UserService(
      storageService: storageService,
      client: client,
    );
  }
  
  /// Servisleri temizler
  void dispose() {
    apiClient.dispose();
  }
} 