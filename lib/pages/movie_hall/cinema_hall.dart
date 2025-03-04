import 'package:cinema/components/components.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/viewmodels/cinema_hall_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CinemaHallsScreen extends StatefulWidget {
  const CinemaHallsScreen({super.key});

  @override
  State<CinemaHallsScreen> createState() => _CinemaHallsScreenState();
}

class _CinemaHallsScreenState extends State<CinemaHallsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late CinemaHallsViewModel _viewModel; 

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<CinemaHallsViewModel>(context, listen: false);
      _viewModel.fetchCinemaData().then((_) {
        if (_viewModel.error == null && _viewModel.cinema != null) {
          _controller.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _viewModel.disposeService(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CinemaHallsViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Appcolor.appBackgroundColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              viewModel.cinema?.name ?? 'Sinema Salonları',
              style: const TextStyle(color: Appcolor.white, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Appcolor.buttonColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: viewModel.isLoading
              ? const CinemaHallsLoader()
              : viewModel.error != null
                  ? CinemaHallsError(error: viewModel.error!)
                  : CinemaHallsContent(
                      viewModel: viewModel,
                      fadeAnimation: _fadeAnimation,
                      slideAnimation: _slideAnimation,
                    ),
        );
      },
    );
  }
}