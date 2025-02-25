import 'package:cinema/core/generated/assets.dart';

class Category {
  final String emoji, name;

  Category({required this.emoji, required this.name});
}

List<Category> categories = [
  Category(
    emoji: AppAssets.smilingFace,
    name: 'Romantik',
  ),
  Category(
    emoji: AppAssets.grinningFace,
    name: 'Komedi',
  ),
  Category(
    emoji: AppAssets.horror,
    name: 'Korku',
  ),
  Category(
    emoji: AppAssets.face,
    name: 'Drama',
  )
];