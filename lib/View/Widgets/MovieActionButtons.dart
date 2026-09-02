import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/Providers/MovieProvider.dart';

class MovieActionButtons extends StatelessWidget {
  final Map<String, dynamic> movie;

  const MovieActionButtons({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () async {
                await provider.toggleFavorite(movie);
              },
              icon: Icon(
                provider.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              label: Text(
                provider.isFavorite
                    ? 'Remove from Favorites'
                    : 'Add to Favorites',
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await provider.toggleWatched(movie);
                    },
                    icon: Icon(
                      provider.isWatched
                          ? Icons.visibility
                          : Icons.visibility_outlined,
                    ),
                    label: const Text('Watched'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await provider.toggleWatchLater(movie);
                    },
                    icon: Icon(
                      provider.isWatchLater
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                    ),
                    label: const Text('Watch Later'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () async {
                await provider.toggleCurrentlyWatching(movie);
              },
              icon: Icon(
                provider.isCurrentlyWatching
                    ? Icons.play_circle
                    : Icons.play_circle_outline,
              ),
              label: Text(
                provider.isCurrentlyWatching
                    ? 'Remove from Currently Watching'
                    : 'Currently Watching',
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
