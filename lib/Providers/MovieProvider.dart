import 'package:flutter/material.dart';
import 'package:movie_app/Controllers/MovieController.dart';
import 'package:movie_app/Models/Movie.dart';

class MovieProvider extends ChangeNotifier {
  final MovieController controller;

  MovieProvider({
    required this.controller,
  });

  List<Movie> movies = [];
  int currentPage = 1;
  bool isLoading = false;

  bool isLoadingMore = false;
  Map<String, dynamic>? movieDetails;
  bool isDetailsLoading = false;
  
  List<Movie> searchResults = [];
  bool isSearching = false;
  String searchQuery = '';
  bool isLoadingMoreSearch = false;
  int searchCurrentPage = 1;

  bool isFavorite = false;
  List<Map<String, dynamic>> favorites = [];
  bool isFavoritesLoading = false;

  bool isWatched = false;
  List<Map<String, dynamic>> watchedMovies = [];
  bool isWatchedLoading = false;

   bool isWatchLater = false;
  List<Map<String, dynamic>> watchLaterMovies = [];
  bool isWatchLaterLoading = false;

  bool isCurrentlyWatching = false;
  List<Map<String, dynamic>> currentlyWatchingMovies = [];
  bool isCurrentlyWatchingLoading = false;

  String? errorMessage;

  

  Future<void> loadMovies() async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      final result =
          await controller.getPopularMovies(1);

      movies = result;
      currentPage = 1;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;

    notifyListeners();
  }


  Future<void> loadMoreMovies() async {
    if (isLoadingMore || isLoading) {
      return;
    }

    isLoadingMore = true;

    notifyListeners();

    try {
      final nextPage = currentPage + 1;

      final result =
          await controller.getPopularMovies(nextPage);

      movies.addAll(result);

      currentPage = nextPage;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoadingMore = false;

    notifyListeners();
  }



  Future<void> loadMovieDetails(
    int movieId,
  ) async {
    isDetailsLoading = true;
    movieDetails = null;
    errorMessage = null;

    notifyListeners();

    try {
      movieDetails =
          await controller.getMovieDetails(movieId);
    } catch (e) {
      errorMessage = e.toString();
    }

    isDetailsLoading = false;

    notifyListeners();
  }

  void clearDetails() {
    movieDetails = null;
    errorMessage = null;

    notifyListeners();
  }
  

  Future<void> searchMovies(
  String query,
) async {
  if (query.trim().isEmpty) {
    searchResults = [];
    searchQuery = '';
    searchCurrentPage = 1;
     
    notifyListeners();
    return;
  }

  isSearching = true;
  searchQuery = query.trim();
  searchCurrentPage = 1;
  errorMessage = null;

  notifyListeners();

  try {
    final result =
        await controller.searchMovies(
      searchQuery,
      searchCurrentPage,
    );

    searchResults = result;
  } catch (e) {
    errorMessage = e.toString();
  }

  isSearching = false;

  notifyListeners();
}

Future<void> loadMoreSearchResults() async {
  if (isLoadingMoreSearch || isSearching) {
    return;
  }

  if (searchQuery.isEmpty) {
    return;
  }

  isLoadingMoreSearch = true;

  notifyListeners();

  try {
    final nextPage = searchCurrentPage + 1;

    final result =
        await controller.searchMovies(
      searchQuery,
      nextPage,
    );

    searchResults.addAll(result);

    searchCurrentPage = nextPage;
  } catch (e) {
    errorMessage = e.toString();
  }

  isLoadingMoreSearch = false;

  notifyListeners();
}



  Future<void> checkFavorite(
    int movieId,
  ) async {
    try {
      isFavorite =
          await controller.isFavorite(movieId);

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(
    Map<String, dynamic> movie,
  ) async {
    try {
      final movieId = movie['id'];

      if (isFavorite) {
        await controller.removeFavorite(movieId);
        isFavorite = false;
      } else {
        await controller.addFavorite(movie);
        isFavorite = true;
      }

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadFavorites() async {
    isFavoritesLoading = true;

    notifyListeners();

    try {
      favorites =
          await controller.getFavorites();
    } catch (e) {
      errorMessage = e.toString();
    }

    isFavoritesLoading = false;

    notifyListeners();
  }

  Future<void> removeFavorite(
    int movieId,
  ) async {
    try {
      await controller.removeFavorite(movieId);

      favorites =
          await controller.getFavorites();

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }


  Future<void> checkWatched(
    int movieId,
  ) async {
    try {
      isWatched =
          await controller.isWatched(movieId);

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleWatched(
    Map<String, dynamic> movie,
  ) async {
    try {
      final movieId = movie['id'];

      if (isWatched) {
        await controller.removeWatched(movieId);
        isWatched = false;
      } else {
        await controller.addWatched(movie);
        isWatched = true;
      }

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
 

  Future<void> checkWatchLater(
    int movieId,
  ) async {
    try {
      isWatchLater =
          await controller.isWatchLater(movieId);

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleWatchLater(
    Map<String, dynamic> movie,
  ) async {
    try {
      final movieId = movie['id'];

      if (isWatchLater) {
        await controller.removeWatchLater(movieId);
        isWatchLater = false;
      } else {
        await controller.addWatchLater(movie);
        isWatchLater = true;
      }

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }


Future<void> loadWatchedMovies() async {
  isWatchedLoading = true;

  notifyListeners();

  try {
    watchedMovies = await controller.getWatched();
  } catch (e) {
    errorMessage = e.toString();
  }

  isWatchedLoading = false;

  notifyListeners();
}

Future<void> removeWatchedMovie(int movieId) async {
  try {
    await controller.removeWatched(movieId);

    watchedMovies = await controller.getWatched();

    notifyListeners();
  } catch (e) {
    errorMessage = e.toString();
    notifyListeners();
  }
}


Future<void> loadWatchLaterMovies() async {
  isWatchLaterLoading = true;

  notifyListeners();

  try {
    watchLaterMovies =
        await controller.getWatchLater();
  } catch (e) {
    errorMessage = e.toString();
  }

  isWatchLaterLoading = false;

  notifyListeners();
}

Future<void> removeWatchLaterMovie(int movieId) async {
  try {
    await controller.removeWatchLater(movieId);

    watchLaterMovies =
        await controller.getWatchLater();

    notifyListeners();
  } catch (e) {
    errorMessage = e.toString();
    notifyListeners();
  }
}


Future<void> checkCurrentlyWatching(
  int movieId,
) async {
  try {
    isCurrentlyWatching =
        await controller.isCurrentlyWatching(movieId);

    notifyListeners();
  } catch (e) {
    errorMessage = e.toString();
    notifyListeners();
  }
}

Future<void> toggleCurrentlyWatching(
  Map<String, dynamic> movie,
) async {
  try {
    final movieId = movie['id'];

    if (isCurrentlyWatching) {
      await controller.removeCurrentlyWatching(movieId);
      isCurrentlyWatching = false;
    } else {
      await controller.addCurrentlyWatching(movie);
      isCurrentlyWatching = true;
    }

    notifyListeners();
  } catch (e) {
    errorMessage = e.toString();
    notifyListeners();
  }
}

Future<void> loadCurrentlyWatchingMovies() async {
  isCurrentlyWatchingLoading = true;

  notifyListeners();

  try {
    currentlyWatchingMovies =
        await controller.getCurrentlyWatching();
  } catch (e) {
    errorMessage = e.toString();
  }

  isCurrentlyWatchingLoading = false;

  notifyListeners();
}

Future<void> removeCurrentlyWatchingMovie(
  int movieId,
) async {
  try {
    await controller.removeCurrentlyWatching(movieId);

    currentlyWatchingMovies =
        await controller.getCurrentlyWatching();

    notifyListeners();
  } catch (e) {
    errorMessage = e.toString();
    notifyListeners();
  }
}
}