part of "../components.dart";


class HallFeature extends StatelessWidget {
  final IconData icon;
  final String label;

  const HallFeature({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Appcolor.buttonColor),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Appcolor.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}