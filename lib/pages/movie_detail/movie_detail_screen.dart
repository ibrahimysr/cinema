import 'package:cinema/components/components.dart';
import 'package:cinema/core/extension/context_extension.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/core/theme/text_style.dart';
import 'package:cinema/core/constants/format_time.dart';
import 'package:cinema/models/movie_model.dart';
import 'package:cinema/pages/reservation/reservation_screen.dart';
import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.appBackgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Film Detayı",
          style: AppTextStyles.headerSmall,
        ),
      ),
      body: Padding(
        padding: context.paddingNormalHorizontal,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               SizedBox(height: context.getDynamicHeight(3)),
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
               SizedBox(height: context.getDynamicHeight(3)),
              Text(
                movie.title,
                style: AppTextStyles.headerLarge,
              ),
              Padding(
                padding: context.paddingNormalVertical, 
                child: Divider(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              const Text(
                "Özet",
                style: AppTextStyles.headerMedium,
              ),
               SizedBox(height: context.getDynamicHeight(2)),
              Text(
                movie.synopsis,
                style: AppTextStyles.bodySmall.copyWith(
                  height: 2,
                  color: Colors.white60,
                ),
              ),
               SizedBox(height: context.getDynamicHeight(5)), 
              
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

               SizedBox(height: context.getDynamicHeight(4)), 
            ],
          ),
        ),
      ),
    );
  }
}
