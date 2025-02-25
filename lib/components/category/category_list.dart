part of "../components.dart";


class GenreCategoryList extends StatelessWidget {
  final AnimationController animationController;
  final List<Animation<double>> genreAnimations;
  final String? selectedGenre;
  final Function(String) onGenreSelected;
  
  const GenreCategoryList({
    Key? key,
    required this.animationController,
    required this.genreAnimations,
    required this.selectedGenre,
    required this.onGenreSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Container(
          height: 60,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: const BoxDecoration(
            color: Colors.black26,
          ),
          child: Consumer<AllMoviesViewModel>(
            builder: (context, allMoviesViewModel, child) {
              if (allMoviesViewModel.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Appcolor.buttonColor,
                  ),
                );
              }
              
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: allMoviesViewModel.genres.length,
                itemBuilder: (context, index) {
                  final genre = allMoviesViewModel.genres[index];
                  final isSelected = genre == selectedGenre;
                  
                  final animationValue = index < genreAnimations.length 
                      ? genreAnimations[index].value.clamp(0.0, 1.0)
                      : 1.0;
                  
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - animationValue)),
                    child: Opacity(
                      opacity: animationValue,
                      child: GestureDetector(
                        onTap: () => onGenreSelected(genre),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Appcolor.buttonColor
                                : Colors.black26,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected 
                                  ? Appcolor.buttonColor.withOpacity(0.8)
                                  : Colors.grey.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              FaIcon(
                                IconHelper.getCategoryIcon(genre),
                                color: isSelected ? Colors.white : Appcolor.buttonColor,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                genre,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isSelected ? Colors.white : Colors.white70,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}