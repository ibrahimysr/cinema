part of "../components.dart";

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
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
                color: Appcolor.white.withValues(alpha:0.8),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}