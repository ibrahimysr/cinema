part of "../components.dart";


class CinemaHallsError extends StatelessWidget {
  final String error;

  const CinemaHallsError({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Appcolor.appBackgroundColor,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
            const SizedBox(height: 16),
            Text(
              error,
              style: const TextStyle(
                color: Appcolor.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Provider.of<CinemaHallsViewModel>(context, listen: false).fetchCinemaData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolor.buttonColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }
}