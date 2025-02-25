class Movie {
  final String poster, title, genre, synopsis;
  final double rating;
  final int duration;
  final String year;
  final String director;
  final String actors;

  Movie({
    required this.poster,
    required this.title,
    required this.genre,
    required this.synopsis,
    required this.rating,
    required this.duration,
    required this.year,
    required this.director,
    required this.actors,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // API'den gelen veri yapısına göre uyarla
    if (json.containsKey('poster_url')) {
      // Yeni API yapısı
      return Movie(
        poster: json['poster_url'] ?? '',
        title: json['title'] ?? '',
        genre: json['genre'] ?? '',
        synopsis: json['description'] ?? '',
        rating: double.tryParse(json['imdb_raiting'] ?? '0.0') ?? 0.0,
        duration: json['duration'] ?? 0,
        year: json['release_date'] != null 
            ? json['release_date'].toString().substring(0, 4) 
            : '',
        director: '', 
        actors: '', 
      );
    } else {
      // Eski API yapısı (vizyondaki filmler)
      int duration = 0;
      if (json['Runtime'] != null && json['Runtime'] != 'N/A') {
        final runtimeStr = json['Runtime'].toString();
        final runtimeMatch = RegExp(r'(\d+)').firstMatch(runtimeStr);
        if (runtimeMatch != null) {
          duration = int.tryParse(runtimeMatch.group(1) ?? '0') ?? 0;
        }
      }

      double rating = 0.0;
      if (json['imdbRating'] != null && json['imdbRating'] != 'N/A') {
        rating = double.tryParse(json['imdbRating']) ?? 0.0;
      }

      return Movie(
        poster: json['Poster'] ?? '',
        title: json['Title'] ?? '',
        genre: json['Genre'] ?? '',
        synopsis: json['Plot'] ?? '',
        rating: rating,
        duration: duration,
        year: json['Year'] ?? '',
        director: json['Director'] ?? '',
        actors: json['Actors'] ?? '',
      );
    }
  }
}

