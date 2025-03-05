import '../../../models/cinema.dart';
import '../api/api_client.dart';

class CinemaService {
  final ApiClient apiClient;

  CinemaService({required this.apiClient});
Future<List<Cinema>> fetchCinemas(int cityId) async {
  try {
    final response = await apiClient.get('cities/$cityId/cinemas');
    print('API Yanıtı: $response');
    if (response['status']) {
      print('data: ${response['data']}');
      return (response['data'] as List) 
          .map((cinema) => Cinema.fromJson(cinema))
          .toList();
    } else {
      print('API Hatası: ${response['message']}');
      throw Exception(response['message']);
    }
  } catch (e) {
    print('CinemaService Hata: $e');
    rethrow;
  }
}
}