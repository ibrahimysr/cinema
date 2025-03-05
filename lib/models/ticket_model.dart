import 'package:flutter/foundation.dart';

@immutable
class TicketCreationResponse {
  final bool status;
  final String message;
  final TicketData data;

  const TicketCreationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TicketCreationResponse.fromJson(Map<String, dynamic> json) {
    return TicketCreationResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: TicketData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

@immutable
class TicketData {
  final int userId;
  final String userName;
  final String userEmail;
  final int showtimeId;
  final String startTime;
  final String movieTitle;
  final String hallName;
  final List<TicketDetail> tickets;
  final double totalAmount;

  const TicketData({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.showtimeId,
    required this.startTime,
    required this.movieTitle,
    required this.hallName,
    required this.tickets,
    required this.totalAmount,
  });

  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(
      userId: json['user_id'] as int,
      userName: json['user_name'] as String,
      userEmail: json['user_email'] as String,
      showtimeId: json['showtime_id'] as int,
      startTime: json['start_time'] as String,
      movieTitle: json['movie_title'] as String,
      hallName: json['hall_name'] as String,
      tickets: (json['tickets'] as List)
          .map((ticketJson) => TicketDetail.fromJson(ticketJson))
          .toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'showtime_id': showtimeId,
      'start_time': startTime,
      'movie_title': movieTitle,
      'hall_name': hallName,
      'tickets': tickets.map((ticket) => ticket.toJson()).toList(),
      'total_amount': totalAmount,
    };
  }
}

@immutable
class TicketDetail {
  final int ticketId;
  final String seatCode;
  final PriceDetails priceDetails;

  const TicketDetail({
    required this.ticketId,
    required this.seatCode,
    required this.priceDetails,
  });

  factory TicketDetail.fromJson(Map<String, dynamic> json) {
    return TicketDetail(
      ticketId: json['ticket_id'] as int,
      seatCode: json['seat_code'] as String,
      priceDetails: PriceDetails.fromJson(json['price_details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticket_id': ticketId,
      'seat_code': seatCode,
      'price_details': priceDetails.toJson(),
    };
  }
}

@immutable
class PriceDetails {
  final double basePrice;
  final double kdv;
  final double otv;
  final double belediyePayi;
  final double totalPrice;

  const PriceDetails({
    required this.basePrice,
    required this.kdv,
    required this.otv,
    required this.belediyePayi,
    required this.totalPrice,
  });

  factory PriceDetails.fromJson(Map<String, dynamic> json) {
    return PriceDetails(
      basePrice: (json['base_price'] as num).toDouble(),
      kdv: (json['kdv'] as num).toDouble(),
      otv: (json['otv'] as num).toDouble(),
      belediyePayi: (json['belediye_payi'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_price': basePrice,
      'kdv': kdv,
      'otv': otv,
      'belediye_payi': belediyePayi,
      'total_price': totalPrice,
    };
  }
}