part of "../components.dart";

class CinemaHallsLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Appcolor.appBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Appcolor.buttonColor),
              strokeWidth: 3,
            ),
            SizedBox(height: 24),
            Text(
              'Sinema bilgileri yükleniyor...',
              style: TextStyle(
                color: Appcolor.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}