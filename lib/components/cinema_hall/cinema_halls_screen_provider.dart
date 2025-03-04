part of "../components.dart";


class CinemaHallsScreenProvider extends StatelessWidget {
  final int movieId; // movieId parametresi
  const CinemaHallsScreenProvider({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CinemaHallsViewModel(),
      child:  CinemaHallsScreen(id: movieId,),
    );
  }
}