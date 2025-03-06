import 'dart:convert';

class Movie {
  final String poster, title, genre, synopsis, language;
  final double rating;
  final int duration, id;
  final String year;
  final String director;
  final String actors;
  final String status;

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
    required this.id,
    required this.language,
    required this.status,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('poster_url')) {
      return Movie(
        poster: json['poster_url'] ?? '',
        title: json['title'] ?? '',
        genre: json['genre'] ?? '',
        synopsis: json['description'] ?? '',
        rating: double.tryParse(json['imdb_raiting']?.toString() ?? '0.0') ?? 0.0,
        duration: json['duration'] ?? 0,
        year: json['release_date'] != null
            ? json['release_date'].toString().substring(0, 4)
            : '',
        director: '', 
        actors: '',   
        id: json['id'] ?? 0,
        language: json['language'] ?? '',
        status: json['status'] ?? '',
      );
    } else {
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
        id: json['id'] ?? 0,
        language: '',
        status: '',   
      );
    }
  }
}

List<Movie> parseMovies(String jsonString) {
  final jsonData = jsonDecode(jsonString);
  if (jsonData is List) {
    return jsonData.map((json) => Movie.fromJson(json)).toList();
  } else if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
    return (jsonData['data'] as List).map((json) => Movie.fromJson(json)).toList();
  }
  return [];
}