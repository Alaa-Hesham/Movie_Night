import 'package:movie_app/Models/Movie.dart';
import 'package:movie_app/Services/TMDBService.dart';
import 'package:movie_app/Services/SQLiteService.dart';

class MovieController {
  final TMDBService tmdbService;
  final SQLiteService sqliteService;

  MovieController({
    required this.tmdbService,
    required this.sqliteService,
  });


  

  Future<List<Movie>> getPopularMovies(int page) async {
    final data = await tmdbService.getPopularMovies(page);

    return data
        .map<Movie>(
          (movie) => Movie.fromJson(
            movie as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<List<Movie>> searchMovies(
    String query,
    int page,
  ) async {
    final data = await tmdbService.searchMovies(
      query,
      page,
    );

    return data
        .map<Movie>(
          (movie) => Movie.fromJson(
            movie as Map<String, dynamic>,
          ),
        )
        .toList();
  }

 
  

  Future<Map<String, dynamic>> getMovieDetails(
    int movieId,
  ) async {
    return await tmdbService.getMovieDetails(movieId);
  }



  Future<void> addFavorite(
    Map<String, dynamic> movie,
  ) async {
    await sqliteService.addFavorite(movie);
  }

  Future<void> removeFavorite(
    int movieId,
  ) async {
    await sqliteService.removeFavorite(movieId);
  }

  Future<bool> isFavorite(
    int movieId,
  ) async {
    return await sqliteService.isFavorite(movieId);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    return await sqliteService.getFavorites();
  }




  Future<void> addWatched(
    Map<String, dynamic> movie,
  ) async {
    await sqliteService.addWatched(movie);
  }

  Future<void> removeWatched(
    int movieId,
  ) async {
    await sqliteService.removeWatched(movieId);
  }

  Future<bool> isWatched(
    int movieId,
  ) async {
    return await sqliteService.isWatched(movieId);
  }

  Future<List<Map<String, dynamic>>> getWatched() async {
    return await sqliteService.getWatched();
  }

 

  Future<void> addWatchLater(
    Map<String, dynamic> movie,
  ) async {
    await sqliteService.addWatchLater(movie);
  }

  Future<void> removeWatchLater(
    int movieId,
  ) async {
    await sqliteService.removeWatchLater(movieId);
  }

  Future<bool> isWatchLater(
    int movieId,
  ) async {
    return await sqliteService.isWatchLater(movieId);
  }

  Future<List<Map<String, dynamic>>> getWatchLater() async {
    return await sqliteService.getWatchLater();
  }
  


Future<void> addCurrentlyWatching(
  Map<String, dynamic> movie,
) async {
  await sqliteService.addCurrentlyWatching(movie);
}

Future<void> removeCurrentlyWatching(
  int movieId,
) async {
  await sqliteService.removeCurrentlyWatching(movieId);
}

Future<bool> isCurrentlyWatching(
  int movieId,
) async {
  return await sqliteService.isCurrentlyWatching(movieId);
}

Future<List<Map<String, dynamic>>>
    getCurrentlyWatching() async {
  return await sqliteService.getCurrentlyWatching();
}

}