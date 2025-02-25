
import 'package:cinema/components/components.dart';
import 'package:cinema/core/extension/context_extension.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/core/theme/text_style.dart';

import 'package:cinema/viewmodels/all_movies_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryMoviesScreen extends StatefulWidget {
  final String? genre;
  final bool showAllGenres;

  const CategoryMoviesScreen({
    Key? key,
    this.genre,
    required this.showAllGenres,
  }) : super(key: key);

  @override
  State<CategoryMoviesScreen> createState() => _CategoryMoviesScreenState();
}

class _CategoryMoviesScreenState extends State<CategoryMoviesScreen>
    with SingleTickerProviderStateMixin {
  String? selectedGenre;
  late AnimationController _animationController;
  final List<Animation<double>> _genreAnimations = [];
  final List<Animation<double>> _movieAnimations = [];

  @override
  void initState() {
    super.initState();
    selectedGenre = widget.genre;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    if (selectedGenre != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<AllMoviesViewModel>(context, listen: false)
            .fetchMoviesByGenre(selectedGenre!);
      });
    }

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupGenreAnimations(int count) {
    _genreAnimations.clear();
    for (int i = 0; i < count; i++) {
      final start = 0.1 + (i * 0.05);
      final end = start + 0.5;
      _genreAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0),
                curve: Curves.easeOutBack),
          ),
        ),
      );
    }
  }

  void _setupMovieAnimations(int count) {
    _movieAnimations.clear();
    for (int i = 0; i < count; i++) {
      final start = 0.2 + (i * 0.03);
      final end = start + 0.4;
      _movieAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0),
                curve: Curves.easeOutCubic),
          ),
        ),
      );
    }
  }

  void _onGenreSelected(String genre) {
    setState(() {
      selectedGenre = genre;
      _movieAnimations.clear();
    });
    Provider.of<AllMoviesViewModel>(context, listen: false)
        .fetchMoviesByGenre(genre);
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final allMoviesViewModel = Provider.of<AllMoviesViewModel>(context);

    if (allMoviesViewModel.genres.isNotEmpty && _genreAnimations.isEmpty) {
      _setupGenreAnimations(allMoviesViewModel.genres.length);
    }

    if (allMoviesViewModel.moviesByGenre.isNotEmpty &&
        _movieAnimations.isEmpty) {
      _setupMovieAnimations(allMoviesViewModel.moviesByGenre.length);
    }

    return Scaffold(
      backgroundColor: Appcolor.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          widget.showAllGenres
              ? "Tüm Kategoriler"
              : selectedGenre ?? "Kategori",
          style: AppTextStyles.headerSmall,
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          if (widget.showAllGenres || selectedGenre == null)
            GenreCategoryList(
              animationController: _animationController,
              genreAnimations: _genreAnimations,
              selectedGenre: selectedGenre,
              onGenreSelected: _onGenreSelected,
            ),
          Expanded(
            child: selectedGenre == null
                ? EmptyState(
                    icon: FontAwesomeIcons.clapperboard,
                    message: "Lütfen bir kategori seçin",
                    animationController: _animationController,
                  )
                : allMoviesViewModel.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Appcolor.buttonColor,
                        ),
                      )
                    : allMoviesViewModel.moviesByGenre.isEmpty
                        ? EmptyState(
                            icon: IconHelper.getCategoryIcon(selectedGenre!),
                            message: "Bu kategoride film bulunamadı",
                            animationController: _animationController,
                          )
                        : Padding(
                            padding: context.paddingNormalHorizontal,
                            child: MovieGrid(
                              movies: allMoviesViewModel.moviesByGenre,
                              animationController: _animationController,
                              movieAnimations: _movieAnimations,
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
