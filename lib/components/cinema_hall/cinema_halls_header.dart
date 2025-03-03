part of "../components.dart";


class CinemaHallsHeader extends StatelessWidget {
  final CinemaSalon cinema;

  const CinemaHallsHeader({required this.cinema});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100, bottom: 10, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  cinema.name,
                  style: TextStyle(
                    color: Appcolor.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Appcolor.grey.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Appcolor.buttonColor, size: 18),
                    SizedBox(width: 4),
                    Text(
                      '4.5',
                      style: TextStyle(
                        color: Appcolor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildInfoItem(Icons.location_on_outlined, cinema.address),
          _buildInfoItem(Icons.phone_outlined, cinema.phone),
          _buildInfoItem(Icons.email_outlined, cinema.email),
          SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildFeatureChip('Otopark'),
              _buildFeatureChip('Cafe'),
              _buildFeatureChip('WiFi'),
              _buildFeatureChip('Engelli Erişimi'),
            ],
          ),
          SizedBox(height: 20),
          Divider(color: Appcolor.grey.withOpacity(0.5), thickness: 1),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Appcolor.buttonColor, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Appcolor.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Appcolor.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Appcolor.white.withOpacity(0.9),
          fontSize: 12,
        ),
      ),
    );
  }
}