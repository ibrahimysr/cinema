import 'dart:math';
import 'package:cinema/const.dart';
import 'package:cinema/core/extension/context_extension.dart';
import 'package:cinema/models/category_model.dart';
import 'package:cinema/models/movie_model.dart';
import 'package:cinema/pages/detail_page.dart';
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
      backgroundColor: appBackgroundColor,
      appBar: headerParts(),
      body: Column(
        children: [
           SizedBox(height: context.getDynamicHeight(4)),
          searchField(),
           SizedBox(height: context.getDynamicHeight(4)),
          Padding(
            padding:  context.paddingNormalHorizontal,
            child: Column(
              children: [
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
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
                        Icon(
                          Icons.arrow_forward_ios,
                          color: buttonColor,
                          size: 15,
                        ),
                      ],
                    )
                  ],
                ),
                 SizedBox(height: context.getDynamicHeight(2)),
                categoryItems(),
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
                  child: Text(
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
                                  builder: (_) => MovieDetailPage(movie: movie),
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
                                      ? buttonColor
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

  Row categoryItems() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        categories.length,
        (index) => Column(
          children: [
            Container(
              padding: context.paddingNormal,
              decoration: BoxDecoration(
                color: Colors.white10.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                categories[index].emoji,
                fit: BoxFit.cover,
                height: 30,
                width: 30,
              ),
            ),
             SizedBox(height: context.getDynamicHeight(1)),
            Text(
              categories[index].name,
              style: AppTextStyles.bodyMedium,
            )
          ],
        ),
      ),
    );
  }

  Padding searchField() {
    return Padding(
      padding:  context.paddingNormalHorizontal,
      child: TextField(
        decoration: InputDecoration(
          contentPadding: 
          
          context.paddingNormalVertical,
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          hintText: "Search",
          hintStyle: const TextStyle(
            color: Colors.white54,
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 35,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

AppBar headerParts() {
  return AppBar(
    backgroundColor: appBackgroundColor,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        // Drawer Button
        IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        // Main Content
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Hoş geldin İbrahim ",
                            style: AppTextStyles.caption,
                          ),
                          TextSpan(
                            text: "👋",
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                     Text(
                      "İstediğin Filmi Seç Ve İzle",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    )
                  ],
                ),
              ),
               SizedBox(width: context.getDynamicWidth(2)),
              Container(
                width: 40,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  
                ),
                child: Icon(Icons.notifications_sharp,color: buttonColor,),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}}