class Movie {
  final String poster, title, genre, synopsis;
  final double rating;
  final int duration;

  Movie({
    required this.poster,
    required this.title,
    required this.genre,
    required this.synopsis,
    required this.rating,
    required this.duration,
  });
}

List<Movie> movies = [
  Movie(
    poster:
        'https://rukminim2.flixcart.com/image/850/1000/jf8khow0/poster/a/u/h/small-hollywood-movie-poster-blade-runner-2049-ridley-scott-original-imaf3qvx88xenydd.jpeg?q=20&crop=false',
    title: 'Blade Runner 2049 ',
    genre: 'Aksiyon',
    synopsis: synopsis,
    rating: 9.0,
    duration: 120,
  ),
 
  Movie(
    poster:
        'https://www.filmsourcing.com/wp-content/uploads/2013/03/comedy-poster-tutorial-5.jpg',
    title: ' Create the scene (and polish)',
    genre: 'Aksiyon',
    synopsis: synopsis,
    rating: 8.0,
    duration: 130,
  ),
  Movie(
      poster:
          'https://m.media-amazon.com/images/M/MV5BNGVjNWI4ZGUtNzE0MS00YTJmLWE0ZDctN2ZiYTk2YmI3NTYyXkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_QL75_UX380_CR0,0,380,562_.jpg',
      title: 'Joker (2019)',
      genre: 'Suç',
      synopsis: synopsis,
      rating: 8.9,
      duration: 140),
  Movie(
    poster: 'https://m.media-amazon.com/images/I/A1jNECCCyUL.jpg',
    title: 'Blue Beetle',
    genre: 'Drama',
    synopsis: synopsis,
    rating: 7.5,
    duration: 150,
  )
];
const String synopsis =
    "Sinopsis: 2147 yılında insanlık, zamanın tek para birimi olduğu distopik bir toplumda yaşıyor. Zeki ama hayal kırıklığına uğramış bir bilim adamı olan Evelyn Carter, zamanı manipüle etmenin bir yolunu keşfeder. Toplumu zamana erişimi düzenleyerek kontrol eden otoriter Zaman Bekçilerinin amansız baskısıyla karşı karşıya kalan Evelyn, kendini yüksek riskli bir kedi fare oyununun içinde bulur.\nEvelyn bu keşfini baskıcı sistemi alt üst etmek için kullanmaya çalışırken, o Zamanın dokusunu değiştirebilecek ve ezilenlerin özgürlüğünü geri kazanabilecek bir devrimi ateşlemeye çalışarak, birlikte bir aldatmaca ve tehlike labirentinde yol alırlar.\nKaosun ortasında, Evelyn kendi geçmişiyle yüzleşir ve icadının gerçek maliyetini sorgular. Zaman Tutucu, her saniyenin önemli olduğu bir dünyada güç, fedakarlık ve amansız adalet arayışı temalarını araştırır.";