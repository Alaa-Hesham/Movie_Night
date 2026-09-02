import 'package:flutter/material.dart';

class SavedMovieCard extends StatelessWidget {
  final Map<String, dynamic> movie;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final String deleteTooltip;
  final IconData deleteIcon;

  const SavedMovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    required this.onDelete,
    required this.deleteTooltip,
    required this.deleteIcon,
  });

  @override
  Widget build(BuildContext context) {
    final posterPath = movie['posterPath'];

    final double rating =
        double.tryParse(movie['rating']?.toString() ?? '0') ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C26),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: SizedBox(
            height: 145,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(18),
                  ),
                  child: SizedBox(
                    width: 100,
                    height: double.infinity,
                    child: posterPath != null &&
                            posterPath.toString().isNotEmpty
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w300$posterPath',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return const Center(
                                child: Icon(
                                  Icons.movie_outlined,
                                  size: 45,
                                  color: Colors.white38,
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Icon(
                              Icons.movie_outlined,
                              size: 45,
                              color: Colors.white38,
                            ),
                          ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      14,
                      14,
                      8,
                      14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie['title'] ?? 'Unknown',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    right: 8,
                    top: 8,
                    bottom: 8,
                  ),
                  child: IconButton(
                    tooltip: deleteTooltip,
                    onPressed: onDelete,
                    icon: Icon(
                      deleteIcon,
                      color: const Color(0xFFB794F4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
