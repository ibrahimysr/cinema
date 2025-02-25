import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'storage_service.dart';
import 'user_service.dart';

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
  
  /// Servisleri başlatır
  Future<void> initialize() async {
    // HTTP istemcisi
    final client = http.Client();
    
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
    // Gerekirse servisleri temizle
  }
} 