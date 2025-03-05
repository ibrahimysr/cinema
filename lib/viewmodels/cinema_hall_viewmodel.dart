import 'package:cinema/core/services/cinema_hall/cinema_hall_service.dart';
import 'package:cinema/models/cinema_salon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CinemaHallsViewModel extends ChangeNotifier {
  final CinemaHallService _cinemaService;
  CinemaSalon? cinema;
  String? error;
  bool isLoading = false;
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Varsayılan bugünün tarihi

  CinemaHallsViewModel({CinemaHallService? service})
      : _cinemaService = service ?? CinemaHallService();

  Future<void> fetchCinemaData({int? movieId, String? date}) async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final cinemaId = prefs.getInt('selectedCinemaId');
      final fetchedMovieId = movieId ?? 1;
      final fetchedDate = date ?? selectedDate; // Tarih yoksa varsayılanı kullan

      if (cinemaId == null) {
        throw Exception('Seçili sinema bulunamadı');
      }

      cinema = await _cinemaService.getCinemaShowtimes(cinemaId, fetchedMovieId, date: fetchedDate);
      error = null;
    } catch (e) {
      error = e.toString();
      cinema = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateDate(String newDate) {
    selectedDate = newDate;
    fetchCinemaData(date: newDate); 
    notifyListeners();
  }

  void disposeService() {
    _cinemaService.dispose();
  }
}