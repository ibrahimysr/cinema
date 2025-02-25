part of "../components.dart";

class MovieInfo extends StatelessWidget {
  final IconData icon;
  final String name;
  final String value;

  const MovieInfo({
    Key? key,
    required this.icon,
    required this.name,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white10.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Appcolor.buttonColor,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white60,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}