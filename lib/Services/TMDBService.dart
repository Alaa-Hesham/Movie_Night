import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBService {
  static const String baseUrl = 'https://api.themoviedb.org/3';

   static const String apiToken = String.fromEnvironment('TMDB_TOKEN');
  Future<List<dynamic>> getPopularMovies(int page) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/movie/popular?language=en-US&page=$page'),
            headers: {
              'Authorization': 'Bearer $apiToken',
              'accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data['results'];
      }

      if (response.statusCode == 401) {
        throw Exception('Invalid API token');
      }

      if (response.statusCode == 404) {
        throw Exception('Movie service not found');
      }

      if (response.statusCode >= 500) {
        throw Exception('TMDB server error');
      }

      throw Exception('Failed to load movies: ${response.statusCode}');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception(
          'Connection timed out. Please check your internet connection.',
        );
      }

      if (e.toString().contains('SocketException')) {
        throw Exception('No internet connection. Please check your network.');
      }

      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/movie/$movieId?language=en-US'),
            headers: {
              'Authorization': 'Bearer $apiToken',
              'accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      if (response.statusCode == 401) {
        throw Exception('Invalid API token');
      }

      if (response.statusCode == 404) {
        throw Exception('Movie not found');
      }

      if (response.statusCode >= 500) {
        throw Exception('TMDB server error');
      }

      throw Exception('Failed to load movie details: ${response.statusCode}');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception(
          'Connection timed out. Please check your internet connection.',
        );
      }

      if (e.toString().contains('SocketException')) {
        throw Exception('No internet connection. Please check your network.');
      }

      rethrow;
    }
  }

  Future<List<dynamic>> searchMovies(String query, int page) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/search/movie'
              '?query=${Uri.encodeComponent(query)}'
              '&language=en-US'
              '&page=$page',
            ),
            headers: {
              'Authorization': 'Bearer $apiToken',
              'accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data['results'];
      }

      if (response.statusCode == 401) {
        throw Exception('Invalid API token');
      }

      if (response.statusCode == 404) {
        throw Exception('Search service not found');
      }

      if (response.statusCode >= 500) {
        throw Exception('TMDB server error');
      }

      throw Exception('Failed to search movies: ${response.statusCode}');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception(
          'Connection timed out. Please check your internet connection.',
        );
      }

      if (e.toString().contains('SocketException')) {
        throw Exception('No internet connection. Please check your network.');
      }

      rethrow;
    }
  }
}
