import 'package:cinema/models/movie_model.dart';

abstract class NowPlayingMovieServiceInterface {
  Future<List<Movie>> getNowPlayingMovies();
} 