import 'package:cinema/components/components.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/models/city.dart';
import 'package:cinema/viewmodels/city_selector_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CitySelector extends StatelessWidget {
  const CitySelector({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Appcolor.appBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'SİNEMA KEŞFİ',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider(
        create: (_) => CitySelectorViewModel(),
        child: const CitySelectorBody(),
      ),
    );
  }
}

class CitySelectorBody extends StatefulWidget {
  const CitySelectorBody({super.key});

  @override
  State<CitySelectorBody> createState() => _CitySelectorBodyState();
}

class _CitySelectorBodyState extends State<CitySelectorBody> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<CitySelectorViewModel>(context, listen: false);
      viewModel.fetchCities();
      viewModel.initSharedPreferences();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Appcolor.appBackgroundColor, Appcolor.grey],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CitySelectorHeader(animationController: _animationController),
              CityDropdown(
                animationController: _animationController,
                onCitySelected: (City? newValue) {
                  if (newValue != null) {
                    final viewModel = Provider.of<CitySelectorViewModel>(context, listen: false);
                    viewModel.setSelectedCity(newValue);
                    _animationController.reset();
                    _animationController.forward();
                  }
                },
              ),
              const SizedBox(height: 30),
              CinemasList(
                animationController: _animationController,
                fadeInAnimation: _fadeInAnimation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}