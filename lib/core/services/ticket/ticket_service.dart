import 'dart:convert';
import 'package:cinema/core/services/base/base_service.dart';
import 'package:cinema/models/cinema_seats_model.dart';
import 'package:cinema/models/ticket_model.dart';
import 'package:http/http.dart' as http;

class TicketService extends BaseService {
  final http.Client _client;

  TicketService({http.Client? client}) : _client = client ?? http.Client();

  @override
  http.Client get httpClient => _client;

  Future<ApiResponse> getShowtimeSeats(int showtimeId) async {
    try {
      final response = await _client.get(
        buildUrl('showtimes/$showtimeId/seats'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ApiResponse.fromJson(jsonData);
      } else {
        throw Exception('API hatası: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }

  Future<TicketCreationResponse> createTickets({
    required int showtimeId,
    required List<Map<String, int>> seats,
    required String token,
  }) async {
    try {
      // Prepare the payload
      final payload = {
        'showtimes_id': showtimeId,
        'seats': seats,
      };

      // Make the API call
      final response = await _client.post(
        buildUrl('tickets/create'),
        headers: {
          ...getAuthHeaders(token),
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      // Check the response status
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the JSON response
        final jsonResponse = json.decode(response.body);
        return TicketCreationResponse.fromJson(jsonResponse);
      } else {
        // Handle error responses
        if (response.statusCode == 401) {
          throw Exception('Yetkilendirme hatası');
        }
        throw Exception('API hatası: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Catch and rethrow any errors
      throw Exception('Ticket oluşturma hatası: $e');
    }
  }
}