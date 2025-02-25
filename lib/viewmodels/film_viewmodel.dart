import 'package:flutter/material.dart';
import 'package:cinema/models/movie_model.dart';
import 'package:cinema/core/services/movie/movie_details_service_interface.dart';
import 'package:cinema/core/services/service_provider.dart';

class FilmViewModel extends ChangeNotifier {
  final MovieDetailsServiceInterface _filmService;
  
  FilmViewModel({MovieDetailsServiceInterface? filmService}) 
      : _filmService = filmService ?? ServiceProvider().filmService;
  
  Movie? _selectedMovie;
  List<Movie> _searchResults = [];
  bool _isLoading = false;
  String _error = '';
  
  Movie? get selectedMovie => _selectedMovie;
  List<Movie> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get error => _error;
  
  Future<void> getMovieDetails(String id) async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      final movie = await _filmService.getMovieDetails(id);
      _selectedMovie = movie;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      final results = await _filmService.searchMovies(query);
      _searchResults = results;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }
} 