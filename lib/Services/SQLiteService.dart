import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SQLiteService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      'movie_app.db',
    );

 

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            userId TEXT NOT NULL,
            id INTEGER NOT NULL,
            title TEXT NOT NULL,
            posterPath TEXT,
            rating REAL,
            overview TEXT,
            releaseDate TEXT,
            PRIMARY KEY (userId, id)
          )
        ''');

        await db.execute('''
          CREATE TABLE watched (
            userId TEXT NOT NULL,
            id INTEGER NOT NULL,
            title TEXT NOT NULL,
            posterPath TEXT,
            rating REAL,
            overview TEXT,
            releaseDate TEXT,
            PRIMARY KEY (userId, id)
          )
        ''');

        await db.execute('''
          CREATE TABLE watch_later (
            userId TEXT NOT NULL,
            id INTEGER NOT NULL,
            title TEXT NOT NULL,
            posterPath TEXT,
            rating REAL,
            overview TEXT,
            releaseDate TEXT,
            PRIMARY KEY (userId, id)
          )
        ''');

        await db.execute('''
          CREATE TABLE currently_watching (
            userId TEXT NOT NULL,
            id INTEGER NOT NULL,
            title TEXT NOT NULL,
            posterPath TEXT,
            rating REAL,
            overview TEXT,
            releaseDate TEXT,
            PRIMARY KEY (userId, id)
          )
        ''');
      },
    );
  }

  String get currentUserId {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No user is logged in');
    }

    return user.uid;
  }
  
  Map<String, dynamic> _movieForDatabase(
    Map<String, dynamic> movie,
  ) {
    return {
      'userId': currentUserId,
      'id': movie['id'],
      'title': movie['title'] ?? 'Unknown',
      'posterPath':
          movie['posterPath'] ?? movie['poster_path'],
      'rating':
          movie['rating'] ??
          movie['vote_average'] ??
          0,
      'overview': movie['overview'] ?? '',
      'releaseDate':
          movie['releaseDate'] ??
          movie['release_date'] ??
          '',
    };
  }




  Future<void> addFavorite(
    Map<String, dynamic> movie,
  ) async {
    final db = await database;

    await db.insert(
      'favorites',
      _movieForDatabase(movie),
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(
    int movieId,
  ) async {
    final db = await database;

    await db.delete(
      'favorites',
      where: 'userId = ? AND id = ?',
      whereArgs: [
        currentUserId,
        movieId,
      ],
    );
  }

  Future<bool> isFavorite(
    int movieId,
  ) async {
    final db = await database;

    final result = await db.query(
      'favorites',
      where: 'userId = ? AND id = ?',
      whereArgs: [
        currentUserId,
        movieId,
      ],
    );

    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>>
      getFavorites() async {
    final db = await database;

    return await db.query(
      'favorites',
      where: 'userId = ?',
      whereArgs: [currentUserId],
      orderBy: 'id DESC',
    );
  }


  Future<void> addWatched(
    Map<String, dynamic> movie,
  ) async {
    final db = await database;

    await db.insert(
      'watched',
      _movieForDatabase(movie),
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<void> removeWatched(
    int movieId,
  ) async {
    final db = await database;

    await db.delete(
      'watched',
      where: 'userId = ? AND id = ?',
      whereArgs: [
        currentUserId,
        movieId,
      ],
    );
  }

  Future<bool> isWatched(
    int movieId,
  ) async {
    final db = await database;

    final result = await db.query(
      'watched',
      where: 'userId = ? AND id = ?',
      whereArgs: [
        currentUserId,
        movieId,
      ],
    );

    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>>
      getWatched() async {
    final db = await database;

    return await db.query(
      'watched',
      where: 'userId = ?',
      whereArgs: [currentUserId],
      orderBy: 'id DESC',
    );
  }

  

  Future<void> addWatchLater(
    Map<String, dynamic> movie,
  ) async {
    final db = await database;

    await db.insert(
      'watch_later',
      _movieForDatabase(movie),
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<void> removeWatchLater(
    int movieId,
  ) async {
    final db = await database;

    await db.delete(
      'watch_later',
      where: 'userId = ? AND id = ?',
      whereArgs: [
        currentUserId,
        movieId,
      ],
    );
  }

  Future<bool> isWatchLater(
    int movieId,
  ) async {
    final db = await database;

    final result = await db.query(
      'watch_later',
      where: 'userId = ? AND id = ?',
      whereArgs: [
        currentUserId,
        movieId,
      ],
    );

    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>>
      getWatchLater() async {
    final db = await database;

    return await db.query(
      'watch_later',
      where: 'userId = ?',
      whereArgs: [currentUserId],
      orderBy: 'id DESC',
    );
  }


  Future<void> addCurrentlyWatching(
    Map<String, dynamic> movie,
  ) async {
    final db = await database;

    await db.insert(
      'currently_watching',
      _movieForDatabase(movie),
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<void> removeCurrentlyWatching(
    int movieId,
  ) async {
    final db = await database;

    await db.delete(
      'currently_watching',
      where: 'userId = ? AND id = ?',
      whereArgs: [
        currentUserId,
        movieId,
      ],
    );
  }

  Future<bool> isCurrentlyWatching(
    int movieId,
  ) async {
    final db = await database;

    final result = await db.query(
      'currently_watching',
      where: 'userId = ? AND id = ?',
      whereArgs: [
        currentUserId,
        movieId,
      ],
    );

    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>>
      getCurrentlyWatching() async {
    final db = await database;

    return await db.query(
      'currently_watching',
      where: 'userId = ?',
      whereArgs: [currentUserId],
      orderBy: 'id DESC',
    );
  }
}
