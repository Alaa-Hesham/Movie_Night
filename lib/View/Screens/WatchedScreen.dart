import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/View/Widgets/SavedMovieCard.dart';
import 'package:movie_app/Providers/MovieProvider.dart';
import 'MovieDetailsScreen.dart';
import 'package:movie_app/View/Widgets/EmptyStateView.dart';
class WatchedScreen extends StatefulWidget {
  const WatchedScreen({super.key});

  @override
  State<WatchedScreen> createState() =>
      _WatchedScreenState();
}

class _WatchedScreenState extends State<WatchedScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().loadWatchedMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Watched Movies',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isWatchedLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

         if (provider.watchedMovies.isEmpty) {
  return const EmptyStateView(
    icon: Icons.visibility_off,
    title: 'No Watched Movies',
    message: 'Movies you mark as watched\nwill appear here.',
  );
}
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.watchedMovies.length,

            itemBuilder: (context, index) {
              final movie =
                  provider.watchedMovies[index];

              return SavedMovieCard(
  movie: movie,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailsScreen(
          movieId: movie['id'],
        ),
      ),
    );
  },

  onDelete: () async {
    await provider.removeWatchedMovie(
      movie['id'],
    );
  },

  deleteTooltip: 'Remove from Watched',

  deleteIcon: Icons.visibility,
 );
            },
          );
        },
      ),
    );
  }
}