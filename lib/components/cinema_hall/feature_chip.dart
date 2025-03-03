part of "../components.dart";




class FeatureChip extends StatelessWidget {
  final String label;

  const FeatureChip({required this.label});

  @override
  Widget build(BuildContext context) {
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