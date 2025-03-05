import 'package:cinema/core/services/auth/auth_service.dart';
import 'package:cinema/core/services/storage/storage_service.dart';
import 'package:cinema/core/services/ticket/ticket_service.dart';
import 'package:cinema/models/cinema_seats_model.dart';
import 'package:cinema/models/ticket_model.dart';
import 'package:flutter/material.dart';

class ReservationViewModel extends ChangeNotifier {
  final TicketService _ticketService;
  final AuthService _authService;

  List<String> selectedSeats = [];
  bool isLoading = true;
  SeatsLayout? seatsLayout;
  ShowtimeData? showtime;
  String? errorMessage;

  ReservationViewModel({
    required TicketService ticketService,
    required AuthService authService,
  }) : _ticketService = ticketService, _authService = authService;

  Future<void> fetchSeats(int showtimeId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _ticketService.getShowtimeSeats(showtimeId);
      seatsLayout = response.seatsLayout;
      showtime = response.showtime;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<TicketCreationResponse?> createTickets(int showtimeId, BuildContext context) async {
    if (selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir koltuk seçin')),
      );
      return null;
    }

    try {
      final token = await _authService.getToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen önce giriş yapın')),
        );
        return null;
      }

      final seatsPayload = seatsLayout!.rows
          .expand((row) => row.seats)
          .where((seat) => selectedSeats.contains(seat.seatCode))
          .map((seat) => {'seat_id': seat.id})
          .toList();

      final ticketResponse = await _ticketService.createTickets(
        showtimeId: showtimeId,
        seats: seatsPayload,
        token: token,
      );
      return ticketResponse;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
      return null;
    }
  }

  void toggleSeatSelection(String seatCode) {
    if (selectedSeats.contains(seatCode)) {
      selectedSeats.remove(seatCode);
    } else {
      selectedSeats.add(seatCode);
    }
    notifyListeners();
  }

  void clearSelection() {
    selectedSeats.clear();
    notifyListeners();
  }
}