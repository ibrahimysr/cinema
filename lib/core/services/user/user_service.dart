import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../models/user_model.dart';
import '../auth/auth_service.dart';
import '../base/base_service.dart';
import '../storage/storage_service.dart';

abstract class UserServiceInterface {
  Future<UserModel?> getUser();
  Future<UserModel> getProfile(String? token);
}

class UserService extends BaseService implements UserServiceInterface {
  final StorageService _storageService;
  final http.Client _client;

  UserService({
    required StorageService storageService,
    http.Client? client,
  })  : _storageService = storageService,
        _client = client ?? http.Client();

  @override
  http.Client get httpClient => _client;

  @override
  Future<UserModel?> getUser() async {
    final userStr = await _storageService.getData<String>(AuthService.userKey);
    if (userStr != null) {
      return UserModel.fromJson(json.decode(userStr));
    }
    return null;
  }

  @override
  Future<UserModel> getProfile(String? token) async {
    if (token == null) {
      throw Exception('Token bulunamadı');
    }

    try {
      final response = await httpClient.get(
        buildUrl('me'),
        headers: getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Map<String, dynamic> userData = responseData['data'];
        
        final user = UserModel.fromJson(userData);
        await _storageService.saveData(
            AuthService.userKey, json.encode(userData));
        return user;
      } else {
        log('Profil bilgileri alınamadı: ${response.body}');
        throw Exception('Profil bilgileri alınamadı: ${response.body}');
      }
    } catch (e) {
      log('Profil bilgileri alınırken hata: $e');
      throw Exception('Profil bilgileri alınırken hata oluştu: $e');
    }
  }
}