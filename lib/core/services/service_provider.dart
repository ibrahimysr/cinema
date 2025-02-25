import 'package:http/http.dart' as http;
import 'api/api_client.dart';
import 'auth/auth_service.dart';
import 'storage/storage_service.dart';
import 'user/user_service.dart';
import 'now_playing_movie/now_playing_movie_service.dart';
import 'now_playing_movie/now_playing_movie_service_interface.dart';
import 'all_movies/all_movies_service.dart';
import 'all_movies/all_movies_service_interface.dart';
import 'movie/movie_details_service.dart';
import 'movie/movie_details_service_interface.dart';

class ServiceProvider {
  static final ServiceProvider _instance = ServiceProvider._internal();
  
  factory ServiceProvider() {
    return _instance;
  }
  
  ServiceProvider._internal();
  
  late final StorageService storageService;
  late final AuthServiceInterface authService;
  late final UserServiceInterface userService;
  late final ApiClient apiClient;
  late final NowPlayingMovieServiceInterface nowPlayingMovieService;
  late final AllMoviesServiceInterface allMoviesService;
  late final MovieDetailsServiceInterface filmService;
  
  Future<void> initialize() async {
    final client = http.Client();
    
    apiClient = ApiClient(client: client);
    
    storageService = HiveStorageService();
    await storageService.init();
    
    authService = AuthService(
      storageService: storageService,
      client: client,
    );
    
    userService = UserService(
      storageService: storageService,
      client: client,
    );
    
    nowPlayingMovieService = NowPlayingMovieService(client: client);
    
    allMoviesService = AllMoviesService(client: client);
    
    filmService = MovieDetailsService(client: client);
  }
  
  void dispose() {
    apiClient.dispose();
  }
} 