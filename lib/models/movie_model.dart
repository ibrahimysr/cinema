// class Movie {
//   final String poster, title, genre, synopsis;
//   final double rating;
//   final int duration;
//   final String year;
//   final String director;
//   final String actors;

//   Movie({
//     required this.poster,
//     required this.title,
//     required this.genre,
//     required this.synopsis,
//     required this.rating,
//     required this.duration,
//     required this.year,
//     required this.director,
//     required this.actors,
//   });

//   factory Movie.fromJson(Map<String, dynamic> json) {
//     // API'den gelen veri yapısına göre uyarla
//     if (json.containsKey('poster_url')) {
//       // Yeni API yapısı
//       return Movie(
//         poster: json['poster_url'] ?? '',
//         title: json['title'] ?? '',
//         genre: json['genre'] ?? '',
//         synopsis: json['description'] ?? '',
//         rating: double.tryParse(json['imdb_raiting'] ?? '0.0') ?? 0.0,
//         duration: json['duration'] ?? 0,
//         year: json['release_date'] != null 
//             ? json['release_date'].toString().substring(0, 4) 
//             : '',
//         director: '', 
//         actors: '', 
//       );
//     } else {
//       // Eski API yapısı (vizyondaki filmler)
//       int duration = 0;
//       if (json['Runtime'] != null && json['Runtime'] != 'N/A') {
//         final runtimeStr = json['Runtime'].toString();
//         final runtimeMatch = RegExp(r'(\d+)').firstMatch(runtimeStr);
//         if (runtimeMatch != null) {
//           duration = int.tryParse(runtimeMatch.group(1) ?? '0') ?? 0;
//         }
//       }

//       double rating = 0.0;
//       if (json['imdbRating'] != null && json['imdbRating'] != 'N/A') {
//         rating = double.tryParse(json['imdbRating']) ?? 0.0;
//       }

//       return Movie(
//         poster: json['Poster'] ?? '',
//         title: json['Title'] ?? '',
//         genre: json['Genre'] ?? '',
//         synopsis: json['Plot'] ?? '',
//         rating: rating,
//         duration: duration,
//         year: json['Year'] ?? '',
//         director: json['Director'] ?? '',
//         actors: json['Actors'] ?? '',
//       );
//     }
//   }
// }

import 'dart:convert';
class Movie {
  final String poster, title, genre, synopsis;
  final double rating;
  final int duration;
  final String year;
  final String director;
  final String actors;
  final int id;

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
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // API'den gelen veri yapısına göre uyarla
    if (json.containsKey('poster_url')) {
      // Yeni API yapısı (bu şu an kullanılmıyor gibi)
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
        id: json['id'] ?? 0,
      );
    } else {
      // Vizyondaki filmler yapısı
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
      );
    }
  }
}

// JSON'dan Movie listesi oluşturma
List<Movie> parseMovies(String jsonString) {
  final jsonData = jsonDecode(jsonString); // JSON stringini decode et
  if (jsonData is List) {
    // Eski yapı: direkt liste geliyordu
    return jsonData.map((json) => Movie.fromJson(json)).toList();
  } else if (jsonData is Map<String, dynamic> && jsonData.containsKey('movies')) {
    // Yeni yapı: movies array'i içinde
    return (jsonData['movies'] as List).map((json) => Movie.fromJson(json)).toList();
  }
  return []; // Hata durumunda boş liste dön
}

