import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/View/Widgets/SavedMovieCard.dart';
import 'package:movie_app/Providers/MovieProvider.dart';
import 'MovieDetailsScreen.dart';
import 'package:movie_app/View/Widgets/EmptyStateView.dart';
class WatchLaterScreen extends StatefulWidget {
  const WatchLaterScreen({super.key});

  @override
  State<WatchLaterScreen> createState() =>
      _WatchLaterScreenState();
}

class _WatchLaterScreenState
    extends State<WatchLaterScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<MovieProvider>()
          .loadWatchLaterMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Watch Later',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {

          if (provider.isWatchLaterLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

         if (provider.watchLaterMovies.isEmpty) {
  return const EmptyStateView(
    icon: Icons.bookmark_border,
    title: 'Watch Later is Empty',
    message: 'Movies you save for later\nwill appear here.',
  );
}
          return ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount:
                provider.watchLaterMovies.length,

            itemBuilder: (context, index) {
              final movie =
                  provider.watchLaterMovies[index];

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
    await provider.removeWatchLaterMovie(
      movie['id'],
    );
  },

  deleteTooltip: 'Remove from Watch Later',

  deleteIcon: Icons.bookmark,
);
            },
          );
        },
      ),
    );
  }

}