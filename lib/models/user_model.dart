class TicketItem {
  final int ticketId;
  final String movieTitle;
  final String showtime;
  final String cinemaName;
  final String hallName;
  final String seatCode;
  final String price;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final String purchaseDate;

  TicketItem({
    required this.ticketId,
    required this.movieTitle,
    required this.showtime,
    required this.cinemaName,
    required this.hallName,
    required this.seatCode,
    required this.price,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.purchaseDate,
  });

  factory TicketItem.fromJson(Map<String, dynamic> json) {
    return TicketItem(
      ticketId: json['ticket_id'],
      movieTitle: json['movie_title'],
      showtime: json['showtime'],
      cinemaName: json['cinema_name'],
      hallName: json['hall_name'],
      seatCode: json['seat_code'],
      price: json['price'],
      status: json['status'],
      paymentStatus: json['payment_status'],
      paymentMethod: json['payment_method'],
      purchaseDate: json['purchase_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticket_id': ticketId,
      'movie_title': movieTitle,
      'showtime': showtime,
      'cinema_name': cinemaName,
      'hall_name': hallName,
      'seat_code': seatCode,
      'price': price,
      'status': status,
      'payment_status': paymentStatus,
      'payment_method': paymentMethod,
      'purchase_date': purchaseDate,
    };
  }
}

class UserModel {
  final int userId;
  final String userName;
  final String userEmail;
  final int ticketTotalCount;
  final List<TicketItem> ticketItems;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.ticketTotalCount,
    required this.ticketItems,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
  List<TicketItem> tickets = [];
  if (json['ticket_items'] != null) {
    var ticketList = json['ticket_items'] as List;
    tickets = ticketList.map((i) => TicketItem.fromJson(i)).toList();
  }

  return UserModel(
    userId: json['user_id'],
    userName: json['user_name'],
    userEmail: json['user_email'],
    ticketTotalCount: json['ticket_total_count'],
    ticketItems: tickets,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'ticket_total_count': ticketTotalCount,
      'ticket_items': ticketItems.map((item) => item.toJson()).toList(),
    };
  }
}