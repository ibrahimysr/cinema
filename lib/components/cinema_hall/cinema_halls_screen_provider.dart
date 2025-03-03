part of "../components.dart";


class CinemaHallsScreenProvider extends StatelessWidget {
  const CinemaHallsScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CinemaHallsViewModel(),
      child: const CinemaHallsScreen(),
    );
  }
}