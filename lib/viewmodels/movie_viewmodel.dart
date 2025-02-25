import 'package:flutter/material.dart';
import 'package:cinema/models/movie_model.dart';
import 'package:cinema/core/services/now_playing_movie/now_playing_movie_service_interface.dart';
import 'package:cinema/core/services/service_provider.dart';

class MovieViewModel extends ChangeNotifier {
  final NowPlayingMovieServiceInterface _nowPlayingMovieService;
  
  MovieViewModel({NowPlayingMovieServiceInterface? nowPlayingMovieService}) 
      : _nowPlayingMovieService = nowPlayingMovieService ?? ServiceProvider().nowPlayingMovieService;
  
  List<Movie> _nowPlayingMovies = [];
  bool _isLoading = false;
  String _error = '';
  
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  bool get isLoading => _isLoading;
  String get error => _error;
  
  Future<void> fetchNowPlayingMovies() async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      final movies = await _nowPlayingMovieService.getNowPlayingMovies();
      _nowPlayingMovies = movies;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
} 