import 'package:cinema/components/components.dart';
import 'package:cinema/const.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/core/theme/text_style.dart';
import 'package:cinema/models/movie_model.dart';
import 'package:cinema/pages/reservation_screen.dart';
import 'package:flutter/material.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;
  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.appBackgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        title: Text(
          "Film Detayı",
          style: AppTextStyles.headerSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              SizedBox(
                height: 335,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: movie.poster,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          movie.poster,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MovieInfo(
                          icon: Icons.videocam_rounded,
                          name: "Tür",
                          value: movie.genre,
                        ),
                        MovieInfo(
                          icon: Icons.timer,
                          name: "Süre",
                          value: formatTime(
                            Duration(minutes: movie.duration),
                          ),
                        ),
                        MovieInfo(
                          icon: Icons.star,
                          name: "Derece",
                          value: "${movie.rating}/10",
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                movie.title,
                style: AppTextStyles.headerLarge,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Divider(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              Text(
                "Özet",
                style: AppTextStyles.headerMedium,
              ),
              const SizedBox(height: 15),
              Text(
                movie.synopsis,
                style: AppTextStyles.bodySmall.copyWith(
                  height: 2,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 30), 
              
              CustomButton(
                text: "Rezervasyon Al",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReservationScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20), 
            ],
          ),
        ),
      ),
    );
  }
}
