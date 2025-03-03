// city_selector_viewmodel.dart
import 'package:cinema/models/city.dart';
import 'package:cinema/models/cinema.dart';
import 'package:cinema/core/services/city/city_service.dart';
import 'package:cinema/core/services/city/cinema_service.dart';
import 'package:cinema/core/services/api/api_client.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CitySelectorViewModel extends ChangeNotifier {
  final CityService _cityService;
  final CinemaService _cinemaService;

  List<City> cities = [];
  List<Cinema> cinemas = [];
  City? selectedCity;
  bool isLoading = true;
  bool isCinemasLoading = false;
  String? errorMessage;

  CitySelectorViewModel({
    CityService? cityService,
    CinemaService? cinemaService,
  })  : _cityService = cityService ?? CityService(apiClient: ApiClient()), // apiClient eklendi
        _cinemaService = cinemaService ?? CinemaService(apiClient: ApiClient()); // apiClient eklendi

  Future<void> fetchCities() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      cities = await _cityService.fetchCities();
      isLoading = false;
      notifyListeners();
    } catch (error) {
      errorMessage = 'Şehirler yüklenirken bir hata oluştu';
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCinemas(int cityId) async {
    try {
      isCinemasLoading = true;
      cinemas = [];
      errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 300));
      cinemas = await _cinemaService.fetchCinemas(cityId);
      isCinemasLoading = false;
      notifyListeners();
    } catch (error) {
      errorMessage = 'Sinemalar yüklenirken bir hata oluştu';
      isCinemasLoading = false;
      notifyListeners();
    }
  }

  void setSelectedCity(City? city) {
    selectedCity = city;
    if (city != null) {
      fetchCinemas(city.id);
    }
    notifyListeners();
  }

  Future<void> saveSelectedCinema(int cityId, int cinemaId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedCityId', cityId);
    await prefs.setInt('selectedCinemaId', cinemaId);
  
  }

  Future<void> initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedCityId');
    await prefs.remove('selectedCinemaId');
  }

  void resetErrorAndRetryCities() {
    errorMessage = null;
    isLoading = true;
    notifyListeners();
    fetchCities();
  }
}