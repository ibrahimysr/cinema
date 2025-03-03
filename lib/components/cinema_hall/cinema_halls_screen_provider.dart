part of "../components.dart";


class CinemaHallsScreenProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CinemaHallsViewModel(),
      child: CinemaHallsScreen(),
    );
  }
}