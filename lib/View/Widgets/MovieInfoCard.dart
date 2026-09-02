import 'package:flutter/material.dart';

class MovieInfoCard extends StatelessWidget {
  final String releaseDate;
  final int runtime;
  final String language;

  const MovieInfoCard({
    super.key,
    required this.releaseDate,
    required this.runtime,
    required this.language,
  });

  Widget infoItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 7),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              infoItem(
                Icons.calendar_today,
                'Release',
                releaseDate,
              ),

              Container(
                width: 1,
                height: 45,
                color: Colors.grey.shade300,
              ),

              infoItem(
                Icons.access_time,
                'Runtime',
                runtime > 0 ? '$runtime min' : 'N/A',
              ),

              Container(
                width: 1,
                height: 45,
                color: Colors.grey.shade300,
              ),

              infoItem(
                Icons.language,
                'Language',
                language.toUpperCase(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}