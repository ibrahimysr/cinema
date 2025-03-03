part of "../components.dart";

class CinemaHallsLoader extends StatelessWidget {
  const CinemaHallsLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Appcolor.appBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Appcolor.buttonColor),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            Text(
              'Sinema bilgileri yükleniyor...',
              style: TextStyle(
                color: Appcolor.white.withValues(alpha:0.8),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}