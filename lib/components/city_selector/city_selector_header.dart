part of "../components.dart";

class CitySelectorHeader extends StatelessWidget {
  final AnimationController animationController;

  const CitySelectorHeader({required this.animationController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, (1 - animationController.value) * 50),
              child: Opacity(
                opacity: animationController.value,
                child: child,
              ),
            );
          },
          child: Text(
            'En iyi filmleri keşfet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8),
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, (1 - animationController.value) * 30),
              child: Opacity(
                opacity: animationController.value,
                child: child,
              ),
            );
          },
          child: Text(
            'Şehrinizdeki sinemaları bulun ve film programlarını görüntüleyin',
            style: TextStyle(
              color: Colors.white.withValues(alpha:0.7),
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}