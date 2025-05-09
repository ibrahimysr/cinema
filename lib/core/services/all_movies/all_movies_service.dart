import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:cinema/models/movie_model.dart';
import 'package:cinema/core/services/base/base_service.dart';
import 'all_movies_service_interface.dart';

class AllMoviesService extends BaseService implements AllMoviesServiceInterface {
  final http.Client _client;

  AllMoviesService({required http.Client client}) : _client = client;

  @override
  http.Client get httpClient => _client;

  @override
  Future<List<Movie>> getAllMovies() async {
    try {
      final url = buildUrl('movies');
      final response = await _client.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is List) {
          return jsonResponse.map((json) => Movie.fromJson(json)).toList();
        } else if (jsonResponse is Map<String, dynamic> &&
            jsonResponse['status'] == true &&
            jsonResponse.containsKey('data')) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => Movie.fromJson(json)).toList();
        } else {
          throw Exception('API\'den beklenen veri yapısı alınamadı');
        }
      } else {
        throw Exception('API\'den tüm film verileri alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      log('Tüm film verileri çekilirken hata oluştu: $e');
      return [];
    }
  }

  @override
  Future<List<Movie>> getMoviesByGenre(String genre) async {
    try {
      final allMovies = await getAllMovies();
      return allMovies
          .where((movie) => movie.genre.toLowerCase().contains(genre.toLowerCase()))
          .toList();
    } catch (e) {
      log('Kategoriye göre film verileri çekilirken hata oluştu: $e');
      return [];
    }
  }
}