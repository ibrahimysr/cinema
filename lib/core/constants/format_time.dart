
String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String digitHours = duration.inHours.remainder(60).toString();
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  return "${digitHours}h ${twoDigitMinutes}m";
}

