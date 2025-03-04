class CinemaSalon {
  final int id;
  final String name;
  final List<Hall> halls;

  CinemaSalon({
    required this.id,
    required this.name,
    required this.halls,
  });

  factory CinemaSalon.fromJson(Map<String, dynamic> json) {
    List<Hall> hallsList = [];
    if (json['halls'] != null) {
      hallsList = List<Hall>.from(json['halls'].map((x) => Hall.fromJson(x)));
    }

    return CinemaSalon(
      id: json['cinema']['id'],
      name: json['cinema']['name'],
      halls: hallsList,
    );
  }
}

class Hall {
  final int id;
  final String name;
  final int capacity;
  final List<Showtime> showtimes;

  Hall({
    required this.id,
    required this.name,
    required this.capacity,
    required this.showtimes,
  });

  factory Hall.fromJson(Map<String, dynamic> json) {
    List<Showtime> showtimesList = [];
    if (json['showtimes'] != null) {
      showtimesList = List<Showtime>.from(json['showtimes'].map((x) => Showtime.fromJson(x)));
    }

    return Hall(
      id: json['id'],
      name: json['name'],
      capacity: json['capacity'],
      showtimes: showtimesList,
    );
  }
}

class Movie1 {
  final int id;
  final String title;
  final int duration;
  final String posterUrl;

  Movie1({
    required this.id,
    required this.title,
    required this.duration,
    required this.posterUrl,
  });

  factory Movie1.fromJson(Map<String, dynamic> json) {
    return Movie1(
      id: json['id'],
      title: json['title'],
      duration: json['duration'] ?? 0,
      posterUrl: json['poster_url'] ?? '',
    );
  }
}

class Showtime {
  final int id;
  final DateTime startTime;
  final DateTime endTime;
  final double? price;

  Showtime({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.price,
  });

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      id: json['id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      price: json['price']?.toDouble(),
    );
  }
}