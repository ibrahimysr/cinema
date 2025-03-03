// cinema_halls_viewmodel.dart
import 'package:cinema/core/services/index.dart';
import 'package:cinema/models/cinema_salon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CinemaHallsViewModel extends ChangeNotifier {
  final CinemaHallService _cinemaService;

  CinemaSalon? cinema;
  bool isLoading = true;
  String? error;

  CinemaHallsViewModel({CinemaHallService? cinemaService}) 
      : _cinemaService = cinemaService ?? CinemaHallService();

  Future<void> fetchCinemaData() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final cityId = prefs.getInt('selectedCityId');
      final cinemaId = prefs.getInt('selectedCinemaId');

      if (cityId == null || cinemaId == null) {
        error = 'Şehir veya sinema ID\'si bulunamadı';
        isLoading = false;
        notifyListeners();
        return;
      }

      cinema = await _cinemaService.getCinemaDetails(cityId, cinemaId);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = 'Hata oluştu: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  void disposeService() {
    _cinemaService.dispose();
  }
}