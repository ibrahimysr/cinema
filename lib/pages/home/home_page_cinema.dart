import 'package:cinema/components/components.dart';
import 'package:cinema/components/drawer/custom_drawer.dart';
import 'package:cinema/core/extension/context_extension.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/viewmodels/movie_viewmodel.dart';
import 'package:cinema/viewmodels/all_movies_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageCinema extends StatefulWidget {
  const HomePageCinema({super.key});

  @override
  State<HomePageCinema> createState() => _HomePageCinemaState();
}

class _HomePageCinemaState extends State<HomePageCinema>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieViewModel>(context, listen: false)
          .fetchNowPlayingMovies();
      Provider.of<AllMoviesViewModel>(context, listen: false).fetchAllMovies();

      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CinemaDrawer(),
      backgroundColor: Appcolor.appBackgroundColor,
      appBar: headerParts(context),
      body: Column(
        children: [
          SizedBox(height: context.getDynamicHeight(4)),
          searchField(context),
          SizedBox(height: context.getDynamicHeight(4)),
          Padding(
            padding: context.paddingNormalHorizontal,
            child: CategorySection(
              animationController: _animationController,
            ),
          ),
          const Expanded(
            child: MovieCarousel(),
          ),
        ],
      ),
    );
  }
}
