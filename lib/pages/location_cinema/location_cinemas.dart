import 'package:cinema/core/theme/color.dart';
import 'package:cinema/core/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CinemaMapScreen extends StatefulWidget {
  const CinemaMapScreen({Key? key}) : super(key: key);

  @override
  State<CinemaMapScreen> createState() => _CinemaMapScreenState();
}

class _CinemaMapScreenState extends State<CinemaMapScreen> {
  final MapController mapController = MapController();
  
  final List<Map<String, dynamic>> cinemas = [
    {
      'name': 'Max Cinema',
      'location': const LatLng(32.7157, -117.1611),
      'distance': '1.2km',
      'rating': 4.7,
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfMwUwnO0Z2IYt162CKjX3eBifprCorgeR_w&s'
    },
    {
      'name': 'Forum Sinema',
      'location': const LatLng(32.7257, -117.1611),
      'distance': '1.24km',
      'rating': 4.5,
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfMwUwnO0Z2IYt162CKjX3eBifprCorgeR_w&s'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.appBackgroundColor,
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: const MapOptions(
              initialCenter: LatLng(32.7157, -117.1611),
              initialZoom: 13.0,
              minZoom: 10,
              maxZoom: 18,
              backgroundColor: Appcolor.appBackgroundColor, 
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                userAgentPackageName: 'com.example.app',
                backgroundColor: Appcolor.appBackgroundColor,
                
                subdomains: const ['a', 'b', 'c', 'd'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: const LatLng(32.7157, -117.1611),
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.my_location, color: Appcolor.appBackgroundColor, size: 20),
                    ),
                  ),
                  ...cinemas.map((cinema) => Marker(
                    point: cinema['location'],
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        _showCinemaDetails(cinema);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.movie,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  )).toList(),
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Cinemas Near You',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey[800]!),
                    ),
                    child: const Row(
                      children: [
                         Icon(Icons.search, color: Colors.white),
                         SizedBox(width: 8),
                         Expanded(
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Sinema ara...',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                         Icon(Icons.tune, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.32,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Appcolor.appBackgroundColor.withValues(alpha:0.9),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cinemas Found (12)',
                        style: AppTextStyles.headerMedium,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See All',
                          style: AppTextStyles.buttonText,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cinemas.length,
                      itemBuilder: (context, index) {
                        final cinema = cinemas[index];
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Appcolor.appBackgroundColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  cinema['image'],
                                  height: 70,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cinema['name'],
                                      style: AppTextStyles.headerSmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'San Diego, California',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on, 
                                          color: Colors.red[400], 
                                          size: 16
                                        ),
                                        Text(
                                          ' ${cinema['distance']}',
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                        Text(
                                          ' ${cinema['rating']}',
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 200),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Icon(Icons.gps_fixed, color: Appcolor.appBackgroundColor),
          onPressed: () {
          },
        ),
      ),
    );
  }

  void _showCinemaDetails(Map<String, dynamic> cinema) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Appcolor.appBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cinema['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red, size: 16),
                Text(
                  ' ${cinema['distance']}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const Spacer(),
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(
                  ' ${cinema['rating']}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}