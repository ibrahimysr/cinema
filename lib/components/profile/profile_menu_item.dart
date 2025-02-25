part of "../components.dart";


Widget buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required BuildContext context
  }) {
    return Padding(
      padding:  EdgeInsets.only(bottom: context.normalValue),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: Appcolor.grey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Appcolor.buttonColor),
               SizedBox(width: context.getDynamicWidth(2)),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }