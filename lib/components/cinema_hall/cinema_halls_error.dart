part of "../components.dart";


class CinemaHallsError extends StatelessWidget {
  final String error;

  const CinemaHallsError({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Appcolor.appBackgroundColor,
      padding: EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
            SizedBox(height: 16),
            Text(
              error,
              style: TextStyle(
                color: Appcolor.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Provider.of<CinemaHallsViewModel>(context, listen: false).fetchCinemaData();
              },
              child: Text('Tekrar Dene'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolor.buttonColor,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}