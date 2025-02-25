import 'package:cinema/models/movie_model.dart';

abstract class MovieDetailsServiceInterface {
  Future<Movie?> getMovieDetails(String id);
  
  Future<List<Movie>> searchMovies(String query);
} 