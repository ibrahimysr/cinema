import 'package:flutter/material.dart';
import 'package:cinema/models/movie_model.dart';
import 'package:cinema/core/services/all_movies/all_movies_service_interface.dart';
import 'package:cinema/core/services/service_provider.dart';

class AllMoviesViewModel extends ChangeNotifier {
  final AllMoviesServiceInterface _allMoviesService;
  
  AllMoviesViewModel({AllMoviesServiceInterface? allMoviesService}) 
      : _allMoviesService = allMoviesService ?? ServiceProvider().allMoviesService;
  
  List<Movie> _allMovies = [];
  List<Movie> _moviesByGenre = [];
  List<String> _genres = [];
  bool _isLoading = false;
  String _error = '';
  String _selectedGenre = '';
  
  List<Movie> get allMovies => _allMovies;
  List<Movie> get moviesByGenre => _moviesByGenre;
  List<String> get genres => _genres;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get selectedGenre => _selectedGenre;
  
  Future<void> fetchAllMovies() async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      final movies = await _allMoviesService.getAllMovies();
      _allMovies = movies;
      
      final genreSet = <String>{};
      for (var movie in movies) {
        if (movie.genre.isNotEmpty && movie.genre != 'N/A') {
          final genres = movie.genre.split(', ');
          genreSet.addAll(genres);
        }
      }
      _genres = genreSet.toList()..sort();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchMoviesByGenre(String genre) async {
    _isLoading = true;
    _error = '';
    _selectedGenre = genre;
    notifyListeners();
    
    try {
      final movies = await _allMoviesService.getMoviesByGenre(genre);
      _moviesByGenre = movies;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
} 