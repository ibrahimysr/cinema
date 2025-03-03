part of "../components.dart";


class CinemaHallsStatus extends StatelessWidget {
  final bool isLoading;
  final String? error;

  const CinemaHallsStatus({required this.isLoading, this.error});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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

    if (error != null) {
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
                error!,
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox.shrink();
  }
}