import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/View/Widgets/MovieDetailsPoster.dart';
import 'package:movie_app/View/Widgets/MovieInfoCard.dart';
import 'package:movie_app/View/Widgets/MovieActionButtons.dart';
import 'package:movie_app/Providers/MovieProvider.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailsScreen> createState() =>
      _MovieDetailsScreenState();
}

class _MovieDetailsScreenState
    extends State<MovieDetailsScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MovieProvider>();

      provider.loadMovieDetails(widget.movieId);
      provider.checkFavorite(widget.movieId);
      provider.checkWatched(widget.movieId);
      provider.checkWatchLater(widget.movieId);
      provider.checkCurrentlyWatching(widget.movieId);  

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),

      appBar: AppBar(
        title: const Text(
          'Movie Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {

          if (provider.isDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.movieDetails == null) {
            return Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.movie_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Could not load movie details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton.icon(
                    onPressed: () {
                      provider.loadMovieDetails(
                        widget.movieId,
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final movie = provider.movieDetails!;

          final String? posterPath =
              movie['poster_path'];

          final String? backdropPath =
              movie['backdrop_path'];

          final String title =
              movie['title'] ?? 'Unknown';

          final String overview =
              movie['overview'] ??
              'No overview available.';

          final double rating =
              (movie['vote_average'] ?? 0).toDouble();

          final String releaseDate =
              movie['release_date'] ??
              'Unknown';

          final int runtime =
              movie['runtime'] ?? 0;

          final List genres =
              movie['genres'] ?? [];

          final String language =
              movie['original_language'] ??
              'Unknown';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                 MovieDetailsPoster(
                 backdropPath: backdropPath,
                 posterPath: posterPath,
                  ),  

                  const SizedBox(height: 85),

              
                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(
                        title,

                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),
                      
                      Row(
                        children: [

                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(20),
                              color:
                                  Colors.amber.shade100,
                            ),

                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 20,
                                  color: Colors.amber,
                                ),

                                const SizedBox(width: 5),

                                Text(
                                  rating
                                      .toStringAsFixed(1),

                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    color: const Color(0xFF33245A),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),
              
                          Text(
                            releaseDate,

                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),


                  MovieInfoCard(
                  releaseDate: releaseDate,
                 runtime: runtime,
                 language: language,
                 ),
                const SizedBox(height: 20),

                if (genres.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Text(
                          'Genres',

                          style: TextStyle(
                            fontSize: 21,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,

                          children:
                              genres.map<Widget>(
                            (genre) {
                              return Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 13,
                                  vertical: 8,
                                ),

                                decoration:
                                    BoxDecoration(
                                  borderRadius:
                                      BorderRadius
                                          .circular(20),
                                  color: const Color(0xFF242430),
                                ),

                                child: Text(
                                  genre['name'] ??
                                      'Unknown',

                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.w500,

                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 25),
                
                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      const Text(
                        'Overview',

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        overview,

                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),


                MovieActionButtons(
                 movie: movie,
                 ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
