part of "../components.dart";


class HallFeature extends StatelessWidget {
  final IconData icon;
  final String label;

  const HallFeature({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Appcolor.buttonColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Appcolor.white.withValues(alpha:0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}