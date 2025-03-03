import '../../../models/cinema.dart';
import '../api/api_client.dart';

class CinemaService {
  final ApiClient apiClient;

  CinemaService({required this.apiClient});

  Future<List<Cinema>> fetchCinemas(int cityId) async {
    final response = await apiClient.get('v1/cities/$cityId/cinemas');
    if (response['status']) {
      return (response['cinemas'] as List)
          .map((cinema) => Cinema.fromJson(cinema))
          .toList();
    } else {
      throw Exception(response['message']);
    }
  }
} 