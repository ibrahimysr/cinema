part of "../components.dart";


class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final AnimationController animationController;
  
  const EmptyState({
    Key? key,
    required this.icon,
    required this.message,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final animation = CurvedAnimation(
          parent: animationController,
          curve: Curves.elasticOut,
        );
        
        final scaleValue = animation.value.clamp(0.0, 1.0);
        
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: scaleValue,
                child: FaIcon(
                  icon,
                  color: Colors.white24,
                  size: 80,
                ),
              ),
              const SizedBox(height: 24),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animationController,
                  curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
                )),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: const Interval(0.3, 1.0),
                    ),
                  ),
                  child: Text(
                    message,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 