import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:cinema/models/movie_model.dart';
import 'package:cinema/core/services/base/base_service.dart';
import 'now_playing_movie_service_interface.dart';

class NowPlayingMovieService extends BaseService implements NowPlayingMovieServiceInterface {
  final http.Client _client;
  
  NowPlayingMovieService({required http.Client client}) : _client = client;
  
  @override
  http.Client get httpClient => _client;
  
  @override
  Future<List<Movie>> getNowPlayingMovies() async {
    try {
      final url = buildUrl('movies/now-playing');
      final response = await _client.get(
        url,
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        return parseMovies(response.body);
      } else {
        throw Exception('API\'den vizyondaki film verileri alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      log('Vizyondaki film verileri çekilirken hata oluştu: $e');
      return []; 
    }
  }

  List<Movie> parseMovies(String jsonString) {
    try {
      final jsonData = jsonDecode(jsonString);
      if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
        return (jsonData['data'] as List).map((json) => Movie.fromJson(json)).toList();
      } else if (jsonData is List) {
        return jsonData.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Beklenmeyen JSON formatı');
      }
    } catch (e) {
      log('JSON parse edilirken hata oluştu: $e');
      return [];
    }
  }
}