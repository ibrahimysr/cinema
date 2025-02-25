part of "../components.dart";


class CategorySection extends StatelessWidget {
  final AnimationController animationController;
  
  const CategorySection({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Kategoriler",
              style: AppTextStyles.headerMedium,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) => 
                      const CategoryMoviesScreen(
                        showAllGenres: true,
                      ),
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
              child: Row(
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
              ),
            )
          ],
        ),
        SizedBox(height: context.getDynamicHeight(2)),
        Consumer<AllMoviesViewModel>(
          builder: (context, allMoviesViewModel, child) {
            if (allMoviesViewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Appcolor.buttonColor,
                ),
              );
            }
            
            if (allMoviesViewModel.error.isNotEmpty) {
              return Center(
                child: Text(
                  'Kategoriler yüklenirken bir hata oluştu',
                  style: AppTextStyles.bodySmall,
                ),
              );
            }
            
            final genres = allMoviesViewModel.genres;
            
            if (genres.isEmpty) {
              return Center(
                child: Text(
                  'Kategori bulunamadı',
                  style: AppTextStyles.bodySmall,
                ),
              );
            }
            
            final displayGenres = genres.length > 4 ? genres.sublist(0, 4) : genres;
            
            return AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    displayGenres.length,
                    (index) {
                      // Her kategori için animasyon değeri
                      final animation = CurvedAnimation(
                        parent: animationController,
                        curve: Interval(
                          0.1 + (index * 0.1),
                          0.6 + (index * 0.1),
                          curve: Curves.elasticOut,
                        ),
                      );
                      
                      // Animasyon değerini sınırla
                      final animationValue = animation.value.clamp(0.0, 1.0);
                      
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 500),
                              pageBuilder: (context, animation, secondaryAnimation) => 
                                CategoryMoviesScreen(
                                  genre: displayGenres[index],
                                  showAllGenres: false,
                                ),
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
                        child: Transform.scale(
                          scale: animationValue,
                          child: Column(
                            children: [
                              Container(
                                padding: context.paddingNormal,
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: FaIcon(
                                  IconHelper.getCategoryIcon(displayGenres[index]),
                                  color: Appcolor.buttonColor,
                                  size: 28,
                                ),
                              ),
                              SizedBox(height: context.getDynamicHeight(1)),
                              Text(
                                displayGenres[index],
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white70,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
        SizedBox(height: context.getDynamicHeight(3)),
      ],
    );
  }
} 