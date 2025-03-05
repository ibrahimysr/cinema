import 'package:cinema/pages/city_selector/city_selector.dart';
import 'package:cinema/core/services/service_provider.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/pages/auth/login_screen.dart';
import 'package:cinema/viewmodels/all_movies_viewmodel.dart';
import 'package:cinema/viewmodels/auth_viewmodel.dart';
import 'package:cinema/viewmodels/cinema_hall_viewmodel.dart';
import 'package:cinema/viewmodels/movie_viewmodel.dart';
import 'package:cinema/viewmodels/film_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await ServiceProvider().initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => MovieViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => AllMoviesViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => FilmViewModel(),), 
        ChangeNotifierProvider(
      create: (context) => CinemaHallsViewModel(),)
      ],
      child: MaterialApp(
        title: 'Cinema App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Appcolor.appBackgroundColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Appcolor.buttonColor,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        home: Consumer<AuthViewModel>(
          builder: (context, authViewModel, child) {
            if (authViewModel.isLoggedIn) {
              return const LoginScreen();
            } else {
              return const CitySelector();
            }
          },
        ),
      ),
    );
  }
}



