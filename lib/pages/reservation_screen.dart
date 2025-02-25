import 'package:cinema/components/components.dart';
import 'package:cinema/const.dart';
import 'package:cinema/pages/cinema_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/seats_model.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

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
  }

  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
    
    final containerSize = screenWidth * 0.08; 
    final fontSize = containerSize * 0.35; 
    final spacing = containerSize * 0.3; 
    final aisleSpacing = containerSize * 0.8; 
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          "Koltuk Seçin",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView( 
        child: Column(
          children: [
            const SizedBox(height: 30),
            wlecomeBorder(context),
            const SizedBox(height: 20),
            // Seats section
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ...List.generate(
                      numRow.length,
                      (colIndex) {
                        int numCol =
                            colIndex == 0 || colIndex == numRow.length - 1 ? 6 : 8;
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: colIndex == numRow.length - 1 ? 0 : spacing,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(numCol, (rowIndex) {
                                String seatNum = '${numRow[colIndex]}${rowIndex + 1}';
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedSeats.contains(seatNum)) {
                                        selectedSeats.remove(seatNum);
                                      } else if (!reservedSeats.contains(seatNum)) {
                                        selectedSeats.add(seatNum);
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: containerSize,
                                    width: containerSize,
                                    margin: EdgeInsets.only(
                                        right: rowIndex == (numCol / 2) - 1 
                                            ? aisleSpacing 
                                            : spacing),
                                    decoration: BoxDecoration(
                                      color: reservedSeats.contains(seatNum)
                                          ? Colors.white
                                          : selectedSeats.contains(seatNum)
                                              ? buttonColor
                                              : grey,
                                      borderRadius: BorderRadius.circular(containerSize * 0.2),
                                    ),
                                    child: Center(
                                      child: FittedBox(
                                        child: Padding(
                                          padding: EdgeInsets.all(containerSize * 0.1),
                                          child: Text(
                                            seatNum,
                                            style: TextStyle(
                                              color: reservedSeats.contains(seatNum)
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
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SeatStatus(
                  color: grey,
                  status: 'Mevcut',
                ),
                SizedBox(width: 10),
                SeatStatus(
                  color: buttonColor,
                  status: 'Seçildi',
                ),
                SizedBox(width: 10),
                SeatStatus(
                  color: Colors.white,
                  status: 'Rezerve',
                ),
              ],
            ),
            const SizedBox(height: 30),
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
                  const SizedBox(height: 35),
                  // Date selection
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
                                          ? appBackgroundColor
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
                  const SizedBox(height: 35),
                  // Time selection
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
                              color: grey,
                              border: Border.all(
                                  width: 2,
                                  color: DateFormat('HH:mm')
                                              .format(selectedTime)
                                              .toString() ==
                                          availableTime[index]
                                      ? buttonColor
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
                                    ? buttonColor
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CinemaMainScreen(),));
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Text(
                                  'Continue',
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

 Padding wlecomeBorder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        height: 65,
        child: Stack(
          children: [
            Positioned(
              top: -5,
              width: MediaQuery.of(context).size.width - 50,
              child: ClipPath(
                clipper: ClipBorder(),
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        buttonColor.withOpacity(0.3),
                        Colors.transparent
                      ],
                      stops: const [
                        0.35,
                        1,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -10,
              width: MediaQuery.of(context).size.width - 50,
              child: ClipPath(
                clipper: ClipShadow(),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  color: buttonColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClipShadow extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, -20, size.width, size.height);
    path.lineTo(size.width, size.height - 5);
    path.quadraticBezierTo(size.width / 2, -25, 0, size.height - 5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ClipBorder extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height - 30);
    path.quadraticBezierTo(size.width / 2, -20, 0, size.height - 30);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}



 