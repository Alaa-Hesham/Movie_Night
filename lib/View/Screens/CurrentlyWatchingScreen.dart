import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/View/Widgets/SavedMovieCard.dart';
import 'package:movie_app/Providers/MovieProvider.dart';
import 'package:movie_app/View/Widgets/EmptyStateView.dart';
import 'MovieDetailsScreen.dart';

class CurrentlyWatchingScreen
    extends StatefulWidget {
  const CurrentlyWatchingScreen({super.key});

  @override
  State<CurrentlyWatchingScreen> createState() =>
      _CurrentlyWatchingScreenState();
}

class _CurrentlyWatchingScreenState
    extends State<CurrentlyWatchingScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<MovieProvider>()
          .loadCurrentlyWatchingMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Currently Watching',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {

          if (provider.isCurrentlyWatchingLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.currentlyWatchingMovies.isEmpty) {
            return const EmptyStateView(
              icon: Icons.play_circle_outline,
              title: 'Nothing Watching Now',
              message:
                  'Movies you are currently watching\nwill appear here.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount:
                provider.currentlyWatchingMovies.length,

            itemBuilder: (context, index) {
              final movie =
                  provider.currentlyWatchingMovies[index];

              return SavedMovieCard(
                movie: movie,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MovieDetailsScreen(
                        movieId: movie['id'],
                      ),
                    ),
                  );
                },

                onDelete: () async {
                  await provider
                      .removeCurrentlyWatchingMovie(
                    movie['id'],
                  );
                },

                deleteTooltip:
                    'Remove from Currently Watching',

                deleteIcon:
                    Icons.play_circle,
              );
            },
          );
        },
      ),
    );
  }
}

