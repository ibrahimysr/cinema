part of "../components.dart";


class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final AnimationController animationController;
  final List<Animation<double>> movieAnimations;
  
  const MovieGrid({
    Key? key,
    required this.movies,
    required this.animationController,
    required this.movieAnimations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            
            final animationValue = index < movieAnimations.length 
                ? movieAnimations[index].value.clamp(0.0, 1.0)
                : 1.0;
            
            return Transform.scale(
              scale: animationValue,
              child: Opacity(
                opacity: animationValue,
                child: _buildMovieCard(context, movie),
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildMovieCard(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) => 
              MovieDetailScreen(movie: movie),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: movie.poster,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius:  BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          movie.poster,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.circleExclamation,
                                  color: Colors.white54,
                                  size: 30,
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                                stops: const [0.6, 1.0],
                              ),
                            ),
                          ),
                        ),
                        if (movie.year.isNotEmpty && movie.year != 'N/A')
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Appcolor.buttonColor.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                movie.year,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: context.paddingNormal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                   SizedBox(height: context.getDynamicHeight(0.5)),
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.solidStar,
                        color: Colors.amber,
                        size: 14,
                      ),
                       SizedBox(width: context.getDynamicWidth(1)),
                      Text(
                        "${movie.rating}/10",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const Spacer(),
                      if (movie.duration > 0)
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.clock,
                              color: Colors.white60,
                              size: 12,
                            ),
                       SizedBox(width: context.getDynamicWidth(1)),
                            Text(
                              "${movie.duration} dk",
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 