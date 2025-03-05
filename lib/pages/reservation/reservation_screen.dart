import 'package:cinema/components/components.dart';
import 'package:cinema/core/extension/context_extension.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/core/theme/text_style.dart';
import 'package:cinema/models/cinema_seats_model.dart';
import 'package:cinema/pages/main/cinema_main_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReservationScreen extends StatefulWidget {
  final int showtimeId;

  const ReservationScreen({
    required this.showtimeId,
    super.key,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List<String> selectedSeats = [];
  bool isLoading = true;
  SeatsLayout? seatsLayout;
  ShowtimeData? showtime;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchSeats();
  }

  Future<void> fetchSeats() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.10.27.21:8000/api/showtimes/${widget.showtimeId}/seats'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData);

        setState(() {
          seatsLayout = apiResponse.seatsLayout;
          showtime = apiResponse.showtime;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'API hatası: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Bağlantı hatası: $e';
        isLoading = false;
      });
    }
  }

  Widget wlecomeBorder(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white),
      ),
      child: const Center(
        child: Text(
          "Perde",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildBottomBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 35),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Toplam Fiyat',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  '${selectedSeats.length * 100}.00₺',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 30),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CinemaMainScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Appcolor.buttonColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Devam Et',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerSize = screenWidth * 0.075;
    final fontSize = containerSize * 0.35;
    final spacing = containerSize * 0.25;
    final aisleSpacing = containerSize * 0.8;

    return Scaffold(
      backgroundColor: Appcolor.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          "Koltuk Seçin",
          style: AppTextStyles.headerMedium,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Appcolor.buttonColor,
                  ),
                )
              : errorMessage != null
                  ? Center(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          wlecomeBorder(context),
                          const SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  ...List.generate(
                                    seatsLayout!.rows.length,
                                    (rowIndex) {
                                      final currentRow = seatsLayout!.rows[rowIndex];
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: rowIndex == seatsLayout!.rows.length - 1 ? 0 : spacing,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ...List.generate(currentRow.seats.length, (seatIndex) {
                                              final seat = currentRow.seats[seatIndex];
                                              final isMiddle = currentRow.seats.length > 6 &&
                                                  seatIndex == (currentRow.seats.length / 2).floor() - 1;
                                              return GestureDetector(
                                                onTap: () {
                                                  if (seat.status == 'active') {
                                                    setState(() {
                                                      if (selectedSeats.contains(seat.seatCode)) {
                                                        selectedSeats.remove(seat.seatCode);
                                                      } else {
                                                        selectedSeats.add(seat.seatCode);
                                                      }
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  height: containerSize*1.3,
                                                  width: containerSize*1.3,
                                                  margin: EdgeInsets.only(
                                                    right: isMiddle ? aisleSpacing : spacing,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: seat.status == 'inactive'
                                                        ? Colors.white
                                                        : selectedSeats.contains(seat.seatCode)
                                                            ? Appcolor.buttonColor
                                                            : Appcolor.grey,
                                                    borderRadius: BorderRadius.circular(containerSize * 0.2),
                                                  ),
                                                  child: Center(
                                                    child: FittedBox(
                                                      child: Padding(
                                                        padding: EdgeInsets.all(containerSize * 0.1),
                                                        child: Text(
                                                          seat.seatCode,
                                                          style: TextStyle(
                                                            color: seat.status == 'inactive'
                                                                ? Colors.black
                                                                : Colors.white,
                                                            fontSize: fontSize,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            })
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: context.getDynamicHeight(15)),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SeatStatus(color: Appcolor.grey, status: 'Mevcut'),
                              SizedBox(width: 10),
                              SeatStatus(color: Appcolor.buttonColor, status: 'Seçildi'),
                              SizedBox(width: 10),
                              SeatStatus(color: Colors.white, status: 'Rezerve'),
                            ],
                          ),
                          SizedBox(height: context.getDynamicHeight(50)), 
                        ],
                      ),
                    ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: buildBottomBar(), 
          ),
        ],
      ),
    );
  }
}