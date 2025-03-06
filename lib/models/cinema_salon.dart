class CinemaSalon {
  final int cinemaId;
  final String cinemaName;
  final int movieId;
  final String movieTitle;
  final int movieDuration;
  final String moviePosterUrl;
  final List<Hall> halls;

  CinemaSalon({
    required this.cinemaId,
    required this.cinemaName,
    required this.movieId,
    required this.movieTitle,
    required this.movieDuration,
    required this.moviePosterUrl,
    required this.halls,
  });

  factory CinemaSalon.fromJson(Map<String, dynamic> json) {
    final showtimesRaw = json['showtimes'] as List;
    final Map<int, Hall> hallMap = {};

    for (var showtimeJson in showtimesRaw) {
      final hallId = showtimeJson['hall_id'] as int;
      if (!hallMap.containsKey(hallId)) {
        hallMap[hallId] = Hall(
          id: hallId,
          name: showtimeJson['hall_name'],
          capacity: showtimeJson['hall_capacity'],
          showtimes: [],
        );
      }
      hallMap[hallId]!.showtimes.add(Showtime.fromJson(showtimeJson));
    }

    return CinemaSalon(
      cinemaId: json['cinema_id'],
      cinemaName: json['cinema_name'],
      movieId: json['movie_id'],
      movieTitle: json['movie_title'],
      movieDuration: json['movie_duration'],
      moviePosterUrl: json['movie_poster_url'],
      halls: hallMap.values.toList(),
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
    throw UnimplementedError();
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
      id: json['movie_id'],
      title: json['movie_title'],
      duration: json['movie_duration'] ?? 0,
      posterUrl: json['movie_poster_url'] ?? '',
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
      id: json['showtime_id'], 
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      price: json['price']?.toDouble(),
    );
  }
}