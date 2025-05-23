part of "../components.dart";


class CinemaHeader extends StatelessWidget {
  final CinemaSalon cinema;

  const CinemaHeader({super.key, required this.cinema});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10,  left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  cinema.cinemaName,
                  style: const TextStyle(
                    color: Appcolor.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Appcolor.grey.withValues(alpha:0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
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
          const SizedBox(height: 20),
          const InfoItem(icon: Icons.location_on_outlined, text: "cinema.address"),
          const InfoItem(icon: Icons.phone_outlined, text: "cinema.phone"),
          const InfoItem(icon: Icons.email_outlined, text: "cinema.email"),
          const SizedBox(height: 24),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FeatureChip(label: 'Otopark'),
              FeatureChip(label: 'Cafe'),
              FeatureChip(label: 'WiFi'),
              FeatureChip(label: 'Engelli Erişimi'),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Appcolor.grey.withValues(alpha:0.5), thickness: 1),
        ],
      ),
    );
  }
}