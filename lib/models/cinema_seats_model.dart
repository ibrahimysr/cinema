
class SeatData {
  final int id;
  final String row;
  final int number;
  final String seatCode;
  final String status;

  SeatData({
    required this.id,
    required this.row,
    required this.number,
    required this.seatCode,
    required this.status,
  });

  factory SeatData.fromJson(Map<String, dynamic> json) {
    return SeatData(
      id: json['id'],
      row: json['row'],
      number: json['number'],
      seatCode: json['seat_code'],
      status: json['status'],
    );
  }
}

class RowData {
  final String row;
  final List<SeatData> seats;

  RowData({
    required this.row,
    required this.seats,
  });

  factory RowData.fromJson(Map<String, dynamic> json) {
    var seatsList = json['seats'] as List;
    List<SeatData> seatData = seatsList.map((i) => SeatData.fromJson(i)).toList();

    return RowData(
      row: json['row'],
      seats: seatData,
    );
  }
}

class SeatsLayout {
  final int totalRows;
  final int seatsPerRow;
  final List<RowData> rows;

  SeatsLayout({
    required this.totalRows,
    required this.seatsPerRow,
    required this.rows,
  });

  factory SeatsLayout.fromJson(Map<String, dynamic> json) {
    var rowsList = json['rows'] as List;
    List<RowData> rowData = rowsList.map((i) => RowData.fromJson(i)).toList();

    return SeatsLayout(
      totalRows: json['total_rows'],
      seatsPerRow: json['seats_per_row'],
      rows: rowData,
    );
  }
}

class ShowtimeData {
  final int id;
  final String startTime;
  final int hallId;
  final String hallName;

  ShowtimeData({
    required this.id,
    required this.startTime,
    required this.hallId,
    required this.hallName,
  });

  factory ShowtimeData.fromJson(Map<String, dynamic> json) {
    return ShowtimeData(
      id: json['showtime_id'],
      startTime: json['showtime_start_time'],
      hallId: json['hall_id'],
      hallName: json['hall_name'],
    );
  }
}

class ApiResponse {
  final bool status;
  final String message;
  final ShowtimeData showtime;
  final SeatsLayout seatsLayout;

  ApiResponse({
    required this.status,
    required this.message,
    required this.showtime,
    required this.seatsLayout,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      message: json['message'],
      showtime: ShowtimeData.fromJson(json['data']), // 'data' içinden alıyoruz
      seatsLayout: SeatsLayout.fromJson(json['data']['seats_layout']), // 'data.seats_layout'
    );
  }
}