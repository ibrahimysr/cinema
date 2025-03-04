// cinema_service.dart
import 'dart:developer';
import 'package:cinema/core/services/api/api_client.dart';
import 'package:cinema/models/cinema_salon.dart';
import 'package:http/http.dart' as http;

class CinemaHallService {
  final ApiClient _apiClient;

  CinemaHallService({http.Client? client}) : _apiClient = ApiClient(client: client);

  Future<CinemaSalon> getCinemaDetails(int cityId, int cinemaId) async {
    try {
      final response = await _apiClient.get('c1/cities/$cityId/cinemas/$cinemaId');
      
      if (response['status'] == true && response['cinema'] != null) {
        return CinemaSalon.fromJson(response['cinema']);
      } else {
        throw Exception('Sinema bilgileri alınamadı');
      }
    } catch (e) {
      log('CinemaService Error: $e');
      rethrow;
    }
  }

  void dispose() {
    _apiClient.dispose();
  }
}