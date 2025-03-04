import 'package:cinema/core/services/cinema_hall/cinema_hall_service.dart';
import 'package:cinema/models/cinema_salon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CinemaHallsViewModel extends ChangeNotifier {
  final CinemaHallService _cinemaService;
  CinemaSalon? cinema;
  String? error;
  bool isLoading = false;

  CinemaHallsViewModel({CinemaHallService? service})
      : _cinemaService = service ?? CinemaHallService();

  Future<void> fetchCinemaData({int? movieId}) async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final cinemaId = prefs.getInt('selectedCinemaId');
      final fetchedMovieId = movieId ?? 1;

      if (cinemaId == null) {
        throw Exception('Seçili sinema bulunamadı');
      }

      cinema = await _cinemaService.getCinemaShowtimes(cinemaId, fetchedMovieId);
      error = null;
    } catch (e) {
      error = e.toString();
      cinema = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void disposeService() {
    _cinemaService.dispose();
  }
}