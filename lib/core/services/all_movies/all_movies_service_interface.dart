import 'package:cinema/models/movie_model.dart';

abstract class AllMoviesServiceInterface {
  Future<List<Movie>> getAllMovies();
  
  Future<List<Movie>> getMoviesByGenre(String genre);
} 