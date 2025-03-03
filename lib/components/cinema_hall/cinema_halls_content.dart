part of "../components.dart";


class CinemaHallsContent extends StatelessWidget {
  final CinemaHallsViewModel viewModel;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const CinemaHallsContent({super.key, 
    required this.viewModel,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.cinema == null) {
      return const Center(
        child: Text('Sinema bilgisi bulunamadı', style: TextStyle(color: Appcolor.white)),
      );
    }

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Appcolor.appBackgroundColor, Appcolor.darkGrey],
            ),
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: CinemaHeader(cinema: viewModel.cinema!)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Appcolor.buttonColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Salonlar',
                        style: TextStyle(
                          color: Appcolor.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: HallCard(hall: viewModel.cinema!.halls[index]),
                          ),
                        ),
                      );
                    },
                    childCount: viewModel.cinema!.halls.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}