part of "../components.dart";

class MovieCarousel extends StatefulWidget {
  const MovieCarousel({Key? key}) : super(key: key);

  @override
  State<MovieCarousel> createState() => _MovieCarouselState();
}

class _MovieCarouselState extends State<MovieCarousel> {
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: Consumer<MovieViewModel>(
            builder: (context, movieViewModel, child) {
              if (movieViewModel.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Appcolor.buttonColor,
                  ),
                );
              }
              
              if (movieViewModel.error.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                       SizedBox(height: context.getDynamicHeight(2)),
                      const Text(
                        'Filmler yüklenirken bir hata oluştu',
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () {
                          movieViewModel.fetchNowPlayingMovies();
                        },
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                );
              }
              
              final movies = movieViewModel.nowPlayingMovies;
              
              if (movies.isEmpty) {
                return const Center(
                  child: Text(
                    'Gösterimde film bulunamadı',
                    style: AppTextStyles.bodyMedium,
                  ),
                );
              }
              
              return Stack(
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
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 500),
                              pageBuilder: (context, animation, secondaryAnimation) => 
                                MovieDetailScreen(movie: movie),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                var begin = const Offset(0.0, 1.0);
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
                                  child: SizedBox(
                                    height: 300,
                                    width: 205,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
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
                                        if (movie.year.isNotEmpty && movie.year != 'N/A')
                                          Positioned(
                                            bottom: 10,
                                            right: 10,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Appcolor.buttonColor.withValues(alpha:0.9),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                movie.year,
                                                style: AppTextStyles.bodySmall.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
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
                    bottom: 0,
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
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
} 