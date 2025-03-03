class City {
  final int id;
  final String name;
  final int cinemaCount;

  City({required this.id, required this.name, required this.cinemaCount});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      cinemaCount: json['cinema_count'],
    );
  }
} 