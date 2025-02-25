  part of "../components.dart";


AppBar headerParts(BuildContext context) {
  return AppBar(
    backgroundColor: Appcolor.appBackgroundColor,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Hoş geldin İbrahim ",
                            style: AppTextStyles.caption,
                          ),
                          TextSpan(
                            text: "👋",
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                     Text(
                      "İstediğin Filmi Seç Ve İzle",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    )
                  ],
                ),
              ),
               SizedBox(width: context.getDynamicWidth(2)),
              Container(
                width: 40,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  
                ),
                child: const Icon(Icons.notifications_sharp,color: Appcolor.buttonColor,),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}