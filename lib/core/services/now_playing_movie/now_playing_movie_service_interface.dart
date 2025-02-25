import 'package:cinema/models/movie_model.dart';

/// Vizyondaki filmler servisi için arayüz
abstract class NowPlayingMovieServiceInterface {
  /// Vizyondaki filmleri getirir
  Future<List<Movie>> getNowPlayingMovies();
} 