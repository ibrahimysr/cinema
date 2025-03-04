import 'dart:developer';
import 'package:cinema/core/services/api/api_client.dart';
import 'package:cinema/models/cinema_salon.dart';
import 'package:http/http.dart' as http;

class CinemaHallService {
  final ApiClient _apiClient;

  CinemaHallService({http.Client? client}) : _apiClient = ApiClient(client: client);

  Future<CinemaSalon> getCinemaShowtimes(int cinemaId, int movieId) async {
    try {
      final response = await _apiClient.get('cinemas/$cinemaId/movies/$movieId/showtimes');

      if (response['status'] == true && response['cinema'] != null) {
        return CinemaSalon.fromJson(response);
      } else {
        throw Exception('Sinema seans bilgileri alınamadı');
      }
    } catch (e) {
      log('CinemaHallService Error: $e');
      rethrow;
    }
  }

  void dispose() {
    _apiClient.dispose();
  }
}