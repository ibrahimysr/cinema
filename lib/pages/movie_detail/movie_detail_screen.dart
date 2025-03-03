import 'package:cinema/components/components.dart';
import 'package:cinema/core/extension/context_extension.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/core/theme/text_style.dart';
import 'package:cinema/core/constants/format_time.dart';
import 'package:cinema/models/movie_model.dart';

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
                    SizedBox(
                      width: 205,
                      height: 300,
                      child: Hero(
                        tag: movie.poster,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            movie.poster,
                            height: 300,
                            width: 205,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 300,
                                width: 205,
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.white54,
                                    size: 50,
                                  ),
                                ),
                              );
                            },
                          ),
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
                        ),
                        MovieInfo(
                          icon: Icons.calendar_today,
                          name: "Yıl",
                          value: movie.year,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: context.getDynamicHeight(3)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      movie.title,
                      style: AppTextStyles.headerLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (movie.year.isNotEmpty && movie.year != 'N/A')
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Appcolor.buttonColor.withValues(alpha:0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        movie.year,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Appcolor.buttonColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: context.paddingNormalVertical,
                child: Divider(
                  color: Colors.white.withValues(alpha:0.1),
                ),
              ),
              if (movie.genre.isNotEmpty && movie.genre != 'N/A')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Türler",
                      style: AppTextStyles.headerMedium,
                    ),
                    SizedBox(height: context.getDynamicHeight(1)),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: movie.genre
                          .split(', ')
                          .map((genre) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                margin: const EdgeInsets.only(bottom: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  genre,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: context.getDynamicHeight(2)),
                  ],
                ),
              if (movie.director.isNotEmpty && movie.director != 'N/A')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Yönetmen",
                      style: AppTextStyles.headerMedium,
                    ),
                    SizedBox(height: context.getDynamicHeight(1)),
                    Text(
                      movie.director,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white60,
                      ),
                    ),
                    SizedBox(height: context.getDynamicHeight(2)),
                  ],
                ),
              if (movie.actors.isNotEmpty && movie.actors != 'N/A')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Oyuncular",
                      style: AppTextStyles.headerMedium,
                    ),
                    SizedBox(height: context.getDynamicHeight(1)),
                    Text(
                      movie.actors,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white60,
                      ),
                    ),
                    SizedBox(height: context.getDynamicHeight(2)),
                  ],
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
                      builder: (_) =>  CinemaHallsScreenProvider(),
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
