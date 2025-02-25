  part of "../components.dart";

  
  Row categoryItems(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        categories.length,
        (index) => Column(
          children: [
            Container(
              padding: context.paddingNormal,
              decoration: BoxDecoration(
                color: Colors.white10.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                categories[index].emoji,
                fit: BoxFit.cover,
                height: 30,
                width: 30,
              ),
            ),
             SizedBox(height: context.getDynamicHeight(1)),
            Text(
              categories[index].name,
              style: AppTextStyles.bodyMedium,
            )
          ],
        ),
      ),
    );
  }