


import 'package:cinema/components/components.dart';
import 'package:cinema/core/extension/context_extension.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/core/theme/text_style.dart';
import 'package:cinema/models/cinema_seats_model.dart';
import 'package:cinema/pages/main/cinema_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class ReservationScreen extends StatefulWidget {
  final int salonId;
  
  const ReservationScreen({
    required this.salonId,
    super.key,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final items = List<DateTime>.generate(15, (index) {
    return DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).add(Duration(days: index));
  });

  DateTime selectedTime = DateTime.now();
  List<String> selectedSeats = [];
  List<String> availableTime = ['10:00', '13:00', '16:00', '19:00', '22:00'];
  
  bool isLoading = true;
  SeatsLayout? seatsLayout;
  ShowtimeData? showtime;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    selectedTime = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(availableTime[0].split(':')[0]),
      int.parse(availableTime[0].split(':')[1]),
    );
    
    fetchSeats();
  }

  Future<void> fetchSeats() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final response = await http.get(
        Uri.parse('http://10.10.27.21:8000/api/showtimes/${widget.salonId}/seats')
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
        style: AppTextStyles.headerMedium
      ),
      centerTitle: true,
    ),
    body: isLoading ? 
      const Center(
        child: CircularProgressIndicator(
          color: Appcolor.buttonColor,
        ),
      ) : 
      errorMessage != null ?
      Center(
        child: Text(
          errorMessage!,
          style: const TextStyle(color: Colors.white),
        ),
      ) :
      SingleChildScrollView( 
        child: Column(
          children: [
            const SizedBox(height: 30),
            wlecomeBorder(context),
            const SizedBox(height: 20),
            
            // Wrap the seat layout in a SingleChildScrollView with horizontal scrolling
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                    if (seat.status == 'available') {
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
                                    height: containerSize,
                                    width: containerSize,
                                    margin: EdgeInsets.only(
                                      right: isMiddle ? aisleSpacing : spacing
                                    ),
                                    decoration: BoxDecoration(
                                      color: seat.status != 'available'
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
                                              color: seat.status != 'available'
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
              SizedBox(height: context.getDynamicHeight(4)),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SeatStatus(
                    color: Appcolor.grey,
                    status: 'Mevcut',
                  ),
                  SizedBox(width: 10),
                  SeatStatus(
                    color: Appcolor.buttonColor,
                    status: 'Seçildi',
                  ),
                  SizedBox(width: 10),
                  SeatStatus(
                    color: Colors.white,
                    status: 'Rezerve',
                  ),
                ],
              ),
              SizedBox(height: context.getDynamicHeight(4)),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 35),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Tarih ve Saati Seçin',
                      style: AppTextStyles.headerSmall,
                    ),
                    SizedBox(height: context.getDynamicHeight(4)),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTime = items[index];
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat('MMM').format(items[index]),
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: DateFormat('d/M/y').format(selectedTime) ==
                                              DateFormat('d/M/y').format(items[index])
                                          ? Colors.white
                                          : Colors.transparent,
                                    ),
                                    child: Text(
                                      DateFormat('dd').format(items[index]),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: DateFormat('d/M/y')
                                                    .format(selectedTime) ==
                                                DateFormat('d/M/y').format(items[index])
                                            ? Appcolor.appBackgroundColor
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: context.getDynamicHeight(1)),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: availableTime.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTime = DateTime(
                                  selectedTime.year,
                                  selectedTime.month,
                                  selectedTime.day,
                                  int.parse(availableTime[index].split(':')[0]),
                                  int.parse(availableTime[index].split(':')[1]),
                                );
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 20),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Appcolor.grey,
                                border: Border.all(
                                    width: 2,
                                    color: DateFormat('HH:mm')
                                                .format(selectedTime)
                                                .toString() ==
                                            availableTime[index]
                                        ? Appcolor.buttonColor
                                        : Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                availableTime[index],
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: DateFormat('HH:mm')
                                              .format(selectedTime)
                                              .toString() ==
                                          availableTime[index]
                                      ? Appcolor.buttonColor
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: context.getDynamicHeight(4)),
                    Padding(
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
                              )
                            ],
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Burada seçili koltukları ve diğer bilgileri API'ye gönderebilirsiniz
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => const CinemaMainScreen(),
                                ));
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
                    )
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }
}