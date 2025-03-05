import 'dart:developer';
import 'package:cinema/core/services/api/api_client.dart';
import 'package:cinema/models/cinema_salon.dart';
import 'package:http/http.dart' as http;

class CinemaHallService {
  final ApiClient _apiClient;

  CinemaHallService({http.Client? client}) : _apiClient = ApiClient(client: client);

  Future<CinemaSalon> getCinemaShowtimes(int cinemaId, int movieId, {required String date}) async {
    try {
      final response = await _apiClient.get('cinemas/$cinemaId/movies/$movieId/showtimes?date=$date');

      if (response['status'] == true && response['data'] != null) {
        return CinemaSalon.fromJson(response['data']); 
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