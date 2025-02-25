import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinema/models/movie_model.dart';
import 'package:cinema/core/services/base/base_service.dart';
import 'movie_details_service_interface.dart';

class MovieDetailsService extends BaseService implements MovieDetailsServiceInterface {
  final http.Client _client;
  
  MovieDetailsService({required http.Client client}) : _client = client;
  
  @override
  http.Client get httpClient => _client;
  
  @override
  Future<Movie?> getMovieDetails(String id) async {
    try {
      final url = buildUrl('movies/$id');
      final response = await _client.get(
        url,
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return Movie.fromJson(data);
      } else {
        throw Exception('API\'den film detayları alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      print('Film detayları çekilirken hata oluştu: $e');
      return null;
    }
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final url = buildUrl('movies/search?q=$query');
      final response = await _client.get(
        url,
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('API\'den film arama sonuçları alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      print('Film arama sonuçları çekilirken hata oluştu: $e');
      return [];
    }
  }
} 