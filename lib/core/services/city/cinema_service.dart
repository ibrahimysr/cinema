import '../../../models/cinema.dart';
import '../api/api_client.dart';

class CinemaService {
  final ApiClient apiClient;

  CinemaService({required this.apiClient});
Future<List<Cinema>> fetchCinemas(int cityId) async {
  try {
    final response = await apiClient.get('cities/$cityId/cinemas');
    if (response['status']) {
      return (response['data'] as List) 
          .map((cinema) => Cinema.fromJson(cinema))
          .toList();
    } else {
      throw Exception(response['message']);
    }
  } catch (e) {
    rethrow;
  }
}
}