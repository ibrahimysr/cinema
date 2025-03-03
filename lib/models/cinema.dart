class Cinema {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final int hallCount;
  final int totalCapacity;
  final int activeHalls;

  Cinema({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.hallCount,
    required this.totalCapacity,
    required this.activeHalls,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      hallCount: json['hall_count'],
      totalCapacity: json['total_capacity'],
      activeHalls: json['active_halls'],
    );
  }
} 