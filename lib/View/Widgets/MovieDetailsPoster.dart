import 'package:flutter/material.dart';

class MovieDetailsPoster extends StatelessWidget {
  final String? backdropPath;
  final String? posterPath;

  const MovieDetailsPoster({
    super.key,
    required this.backdropPath,
    required this.posterPath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: double.infinity,
          height: 260,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (backdropPath != null)
                Image.network(
                  'https://image.tmdb.org/t/p/w780$backdropPath',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: Colors.grey.shade800,
                    );
                  },
                )
              else
                Container(
                  color: Colors.grey.shade800,
                ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        Positioned(
          left: 20,
          bottom: -70,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: posterPath != null
                ? Image.network(
                    'https://image.tmdb.org/t/p/w300$posterPath',
                    width: 125,
                    height: 185,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 125,
                        height: 185,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.movie,
                          size: 50,
                        ),
                      );
                    },
                  )
                : Container(
                    width: 125,
                    height: 185,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.movie,
                      size: 50,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}