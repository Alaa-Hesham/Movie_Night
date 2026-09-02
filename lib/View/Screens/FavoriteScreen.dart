import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/View/Widgets/SavedMovieCard.dart';
import 'package:movie_app/Providers/MovieProvider.dart';
import 'MovieDetailsScreen.dart';
import 'package:movie_app/View/Widgets/EmptyStateView.dart';
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.isFavoritesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

         if (provider.favorites.isEmpty) {
            return const EmptyStateView(
              icon: Icons.favorite_border,
              title: 'No Favorites Yet',
              message: 'Movies you add to favorites\nwill appear here.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              final movie = provider.favorites[index];

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
                  await provider.removeFavorite(
                    movie['id'],
                  );
                },
                deleteTooltip: 'Remove from Favorites',
                deleteIcon: Icons.favorite,
              );
            },
          );
        },
      ),
    );
  }
}