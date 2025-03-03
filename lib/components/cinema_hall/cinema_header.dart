part of "../components.dart";


class CinemaHeader extends StatelessWidget {
  final CinemaSalon cinema;

  const CinemaHeader({required this.cinema});

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
                  color: Appcolor.grey.withValues(alpha:0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Appcolor.buttonColor, size: 18),
                    SizedBox(width: 4),
                    Text(
                      '4.5',
                      style: TextStyle(color: Appcolor.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          InfoItem(icon: Icons.location_on_outlined, text: cinema.address),
          InfoItem(icon: Icons.phone_outlined, text: cinema.phone),
          InfoItem(icon: Icons.email_outlined, text: cinema.email),
          SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FeatureChip(label: 'Otopark'),
              FeatureChip(label: 'Cafe'),
              FeatureChip(label: 'WiFi'),
              FeatureChip(label: 'Engelli Erişimi'),
            ],
          ),
          SizedBox(height: 20),
          Divider(color: Appcolor.grey.withValues(alpha:0.5), thickness: 1),
        ],
      ),
    );
  }
}