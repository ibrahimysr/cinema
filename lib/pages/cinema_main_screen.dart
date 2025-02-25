import 'package:cinema/core/theme/color.dart';
import 'package:cinema/pages/location_cinemas.dart';
import 'package:cinema/pages/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home/home_page_cinema.dart';

class CinemaMainScreen extends StatefulWidget {
  const CinemaMainScreen({super.key});

  @override
  State<CinemaMainScreen> createState() => _CinemaMainScreenState();
}

class _CinemaMainScreenState extends State<CinemaMainScreen> {
  List<IconData> bottomIcons = [
    Icons.home_filled,
    CupertinoIcons.compass_fill,
    CupertinoIcons.ticket_fill,
    Icons.person_rounded
  ];

  int currentIndex = 0;
  late final List<Widget> page;
  @override
  void initState() {
    page = [
      const HomePageCinema(),
      const CinemaMapScreen(),
      navBarPage(CupertinoIcons.ticket_fill),
      const ProfileScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.appBackgroundColor,
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            bottomIcons.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = index;
                });
              },
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: currentIndex == index ? 25 : 0,
                    width: currentIndex == index ? 25 : 0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          spreadRadius: currentIndex == index ? 10 : 0,
                          blurRadius: currentIndex == index ? 15 : 0
                        )
                      ],
                    ),
                  ),
                  Icon(
                    bottomIcons[index],
                    color: currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: page[currentIndex],
    );
  }

  Widget navBarPage(IconData iconName) {
    return Center(
      child: Icon(
        iconName,
        size: 100,
        color: Colors.white,
      ),
    );
  }
}