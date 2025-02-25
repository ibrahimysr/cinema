import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinema/models/movie_model.dart';
import 'package:cinema/core/services/base/base_service.dart';
import 'now_playing_movie_service_interface.dart';

/// Vizyondaki filmler servisi uygulaması
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
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('API\'den vizyondaki film verileri alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      // Hata durumunda boş liste döndür
      print('Vizyondaki film verileri çekilirken hata oluştu: $e');
      return []; // Boş liste döndür
    }
  }
} 