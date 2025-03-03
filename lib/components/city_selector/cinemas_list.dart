part of "../components.dart";


class CinemasList extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> fadeInAnimation;

  const CinemasList({super.key, 
    required this.animationController,
    required this.fadeInAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CitySelectorViewModel>(context);

    if (viewModel.isCinemasLoading) {
      return const Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: Appcolor.buttonColor,
                  strokeWidth: 3,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Sinemalar Yükleniyor...',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.selectedCity != null && viewModel.cinemas.isNotEmpty) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.movie_filter, color: Appcolor.buttonColor),
                const SizedBox(width: 8),
                Text(
                  '${viewModel.selectedCity!.name} Sinemaları',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedBuilder(
                animation: fadeInAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: fadeInAnimation.value,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: viewModel.cinemas.length,
                      itemBuilder: (context, index) {
                        final cinema = viewModel.cinemas[index];
                        return _buildCinemaItem(context, cinema, index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    if (viewModel.selectedCity != null && viewModel.cinemas.isEmpty && !viewModel.isCinemasLoading) {
      return const Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie_rounded, color: Colors.white54, size: 70),
              SizedBox(height: 16),
              Text(
                'Bu şehirde gösterilecek sinema bulunamadı',
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (!viewModel.isLoading && viewModel.selectedCity == null) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: animationController.value,
                    child: child,
                  );
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Appcolor.buttonColor.withValues(alpha:0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.location_on, color: Appcolor.buttonColor, size: 50),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: animationController.value,
                    child: child,
                  );
                },
                child: const Text(
                  'Sinemaları görmek için bir şehir seçin',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildCinemaItem(BuildContext context, Cinema cinema, int index) {
    final viewModel = Provider.of<CitySelectorViewModel>(context, listen: false);
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final itemAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(0.4 + (index * 0.05), 1.0, curve: Curves.easeInOut),
          ),
        );
        return Transform.translate(
          offset: Offset(0, 30 * (1 - itemAnimation.value)),
          child: Opacity(
            opacity: itemAnimation.value,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Appcolor.grey.withValues(alpha:0.5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${cinema.name} seçildi'),
                              backgroundColor: Appcolor.buttonColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                          viewModel.saveSelectedCinema(viewModel.selectedCity!.id, cinema.id);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CinemaMainScreen()));
                        },
                        splashColor: Appcolor.buttonColor.withValues(alpha:0.3),
                        highlightColor: Appcolor.buttonColor.withValues(alpha:0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Appcolor.buttonColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.movie, color: Colors.white, size: 30),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cinema.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          cinema.address,
                                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, color: Appcolor.buttonColor, size: 16),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Divider(color: Colors.white24),
                              const SizedBox(height: 8),
                              Column(
                                children: [
                                  _buildContactInfoRow(Icons.phone, cinema.phone),
                                  const SizedBox(height: 6),
                                  _buildContactInfoRow(
                                    Icons.email,
                                    cinema.email.length > 20 ? '${cinema.email.substring(0, 20)}...' : cinema.email,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildDetailChip(Icons.weekend, '${cinema.hallCount} Salon', Appcolor.grey),
                                  _buildDetailChip(Icons.people, '${cinema.totalCapacity} Kişi', Appcolor.grey),
                                  _buildDetailChip(
                                    Icons.check_circle,
                                    '${cinema.activeHalls} Aktif',
                                    cinema.activeHalls == cinema.hallCount ? Colors.green.shade700 : Colors.orange.shade700,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Appcolor.buttonColor, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailChip(IconData icon, String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha:0.7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}