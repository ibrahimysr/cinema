part of "../components.dart";

class IconHelper {
  static IconData getCategoryIcon(String genre) {
    switch (genre.toLowerCase()) {
      case 'action':
      case 'aksiyon':
        return FontAwesomeIcons.fire;
      case 'adventure':
      case 'macera':
        return FontAwesomeIcons.compass;
      case 'animation':
      case 'animasyon':
        return FontAwesomeIcons.child;
      case 'comedy':
      case 'komedi':
        return FontAwesomeIcons.faceSmile;
      case 'crime':
      case 'suç':
        return FontAwesomeIcons.handcuffs;
      case 'documentary':
      case 'belgesel':
        return FontAwesomeIcons.video;
      case 'drama':
        return FontAwesomeIcons.theaterMasks;
      case 'family':
      case 'aile':
        return FontAwesomeIcons.peopleGroup;
      case 'fantasy':
      case 'fantastik':
        return FontAwesomeIcons.wandMagicSparkles;
      case 'history':
      case 'tarih':
        return FontAwesomeIcons.landmark;
      case 'horror':
      case 'korku':
        return FontAwesomeIcons.ghost;
      case 'music':
      case 'müzik':
        return FontAwesomeIcons.music;
      case 'mystery':
      case 'gizem':
        return FontAwesomeIcons.magnifyingGlass;
      case 'romance':
      case 'romantik':
        return FontAwesomeIcons.heart;
      case 'science fiction':
      case 'bilim kurgu':
        return FontAwesomeIcons.rocket;
      case 'thriller':
      case 'gerilim':
        return FontAwesomeIcons.bolt;
      case 'war':
      case 'savaş':
        return FontAwesomeIcons.shield;
      case 'western':
      case 'kovboy':
        return FontAwesomeIcons.hatCowboy;
      default:
        return FontAwesomeIcons.film;
    }
  }
} 