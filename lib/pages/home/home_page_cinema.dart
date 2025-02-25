import 'dart:math';
import 'package:cinema/components/components.dart';
import 'package:cinema/core/extension/context_extension.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/core/theme/text_style.dart';
import 'package:cinema/models/movie_model.dart';
import 'package:cinema/pages/movie_detail/movie_detail_screen.dart';
import 'package:flutter/material.dart';

class HomePageCinema extends StatefulWidget {
  const HomePageCinema({super.key});

  @override
  State<HomePageCinema> createState() => _HomePageCinemaState();
}

class _HomePageCinemaState extends State<HomePageCinema> {
  late PageController controller;
  double pageoffSet = 1;
  int currentIndex = 1;
  @override
  void initState() {
    super.initState();
    controller = PageController(
      initialPage: 1,
      viewportFraction: 0.6,
    )..addListener(() {
        setState(() {
          pageoffSet = controller.page!;
        });
      });
  }

  void despose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.appBackgroundColor,
      appBar: headerParts(context),
      body: Column(
        children: [
          SizedBox(height: context.getDynamicHeight(4)),
          searchField(context),
          SizedBox(height: context.getDynamicHeight(4)),
          Padding(
            padding: context.paddingNormalHorizontal,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Kategoriler",
                      style: AppTextStyles.headerMedium,
                    ),
                    Row(
                      children: [
                        Text(
                          "Tümünü Gör",
                          style: AppTextStyles.buttonText,
                        ),
                        SizedBox(width: context.getDynamicWidth(2)),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Appcolor.buttonColor,
                          size: 15,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: context.getDynamicHeight(2)),
                categoryItems(context),
                SizedBox(height: context.getDynamicHeight(3)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: context.paddingNormalHorizontal,
                  child: const Text(
                    "Vizyondaki Filmler",
                    style: AppTextStyles.headerLarge,
                  ),
                ),
                SizedBox(height: context.getDynamicHeight(2)),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PageView.builder(
                        controller: controller,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index % movies.length;
                          });
                        },
                        itemBuilder: (context, index) {
                          double scale = max(
                            0.6,
                            (1 - (pageoffSet - index).abs() + 0.6),
                          );
                          double angle = (controller.position.haveDimensions
                                  ? index.toDouble() - (controller.page ?? 0)
                                  : index.toDouble() - 1) *
                              5;
                          angle = angle.clamp(-5, 5);
                          final movie = movies[index % movies.length];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MovieDetailScreen(movie: movie),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 100 - (scale / 1.6 * 100),
                              ),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Transform.rotate(
                                    angle: angle * pi / 90,
                                    child: Hero(
                                      tag: movie.poster,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.network(
                                          movie.poster,
                                          height: 300,
                                          width: 205,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                          top: 330,
                          child: Row(
                            children: List.generate(
                              movies.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(right: 15),
                                width: currentIndex == index ? 30 : 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? Appcolor.buttonColor
                                      : Colors.white24,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
