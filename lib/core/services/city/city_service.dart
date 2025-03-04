
import '../../../models/city.dart';
import '../api/api_client.dart';

class CityService {
  final ApiClient apiClient;

  CityService({required this.apiClient});

  Future<List<City>> fetchCities() async {
    final response = await apiClient.get('c1/cities');
    if (response['status']) {
      return (response['cities'] as List)
          .map((city) => City.fromJson(city))
          .toList();
    } else {
      throw Exception(response['message']);
    }
  }
} 