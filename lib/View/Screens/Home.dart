import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/View/Widgets/MovieCard.dart';
import 'package:movie_app/View/Widgets/FeatureMovieCard.dart';
import 'package:movie_app/View/Widgets/EmptyStateView.dart';
import 'package:movie_app/Models/Movie.dart';
import 'package:movie_app/Providers/MovieProvider.dart';
import 'package:movie_app/Services/FirebaseAuthService.dart';
import 'LoginScreen.dart';
import 'MovieDetailsScreen.dart';
import 'FavoriteScreen.dart';
import 'WatchedScreen.dart';
import 'WatchLaterScreen.dart';
import 'CurrentlyWatchingScreen.dart';
import 'ProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuthService authService = FirebaseAuthService();

  final ScrollController scrollController = ScrollController();

  final TextEditingController searchController = TextEditingController();

  int selectedIndex = 0;

  bool showSearch = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().loadMovies();
    });

    scrollController.addListener(() {
      final provider = context.read<MovieProvider>();

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        if (provider.searchQuery.isNotEmpty) {
          provider.loadMoreSearchResults();
        } else {
          provider.loadMoreMovies();
        }
      }
    });
  }

 

  void search() {
    context.read<MovieProvider>().searchMovies(searchController.text);
  }

  void openSearch() {
    setState(() {
      showSearch = true;
    });
  }

  void clearSearch() {
    searchController.clear();

    context.read<MovieProvider>().searchMovies('');

    setState(() {
      showSearch = false;
    });
  }



  Future<void> logout() async {
    await authService.logOut();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }


  Widget buildHomeContent() {
    return Consumer<MovieProvider>(
      builder: (context, provider, child) {
        final movies = provider.movies;

        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF8B5CF6),
            ),
          );
        }

        if (movies.isEmpty) {
          if (provider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      size: 70,
                      color: Colors.white38,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Couldn't load movies",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: () => provider.loadMovies(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return const EmptyStateView(
            icon: Icons.movie_outlined,
            title: 'No Movies Available',
            message: 'Pull down to refresh and\ntry again.',
          );
        }

        final Movie featured = movies.first;

        final int itemCount =
            movies.length + (provider.isLoadingMore ? 1 : 0);

        return RefreshIndicator(
          color: const Color(0xFF8B5CF6),
          onRefresh: () => provider.loadMovies(),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: FeaturedMovieCard(
                  movie: featured,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieDetailsScreen(
                          movieId: featured.id,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 4),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Popular Movies',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.62,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= movies.length) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF8B5CF6),
                          ),
                        );
                      }

                      final movie = movies[index];

                      return MovieCard(
                        movie: movie,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MovieDetailsScreen(
                                movieId: movie.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: itemCount,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget buildSearchContent() {
    return Consumer<MovieProvider>(
      builder: (context, provider, child) {
        final movies = provider.searchResults;

        if (provider.isSearching) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF8B5CF6),
            ),
          );
        }

        if (provider.searchQuery.isEmpty) {
          return const EmptyStateView(
            icon: Icons.search,
            title: 'Search for a Movie',
            message: 'Find your next favorite\nmovie by title.',
          );
        }

        if (movies.isEmpty) {
          return const EmptyStateView(
            icon: Icons.movie_filter_outlined,
            title: 'No Movies Found',
            message: 'Try a different title\nor check the spelling.',
          );
        }

        final int itemCount =
            movies.length + (provider.isLoadingMoreSearch ? 1 : 0);

        return GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
          itemCount: itemCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (context, index) {
            if (index >= movies.length) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF8B5CF6),
                ),
              );
            }

            final movie = movies[index];

            return MovieCard(
              movie: movie,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieDetailsScreen(movieId: movie.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget buildBody() {
    if (showSearch) {
      return buildSearchContent();
    }

    switch (selectedIndex) {
      case 0:
        return buildHomeContent();
      case 1:
        return const FavoritesScreen();
      case 2:
        return const WatchedScreen();
      case 3:
        return const WatchLaterScreen();
      case 4:
        return const CurrentlyWatchingScreen();
      default:
        return buildHomeContent();
    }
  }


  PreferredSizeWidget buildAppBar() {
    if (showSearch) {
      return AppBar(
        titleSpacing: 16,
        title: TextField(
          controller: searchController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => search(),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(color: Colors.white54),
            prefixIcon: Icon(Icons.search, color: Colors.white54),
            border: InputBorder.none,
            filled: false,
          ),
        ),
        actions: [
          IconButton(
            onPressed: clearSearch,
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      );
    }

    if (selectedIndex == 0) {
      return AppBar(
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Movie Night',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Discover your next favorite movie',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: openSearch,
            icon: const Icon(Icons.search, color: Colors.white, size: 26),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            icon: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 25,
            ),
          ),
          IconButton(
            onPressed: logout,
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
        ],
      );
    }

    String title;

    switch (selectedIndex) {
      case 1:
        title = 'Favorites';
        break;
      case 2:
        title = 'Watched';
        break;
      case 3:
        title = 'Watch Later';
        break;
      case 4:
        title = 'Currently Watching';
        break;
      default:
        title = 'Movie App';
    }

    return AppBar(
      titleSpacing: 20,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
          icon: const Icon(
            Icons.person_outline,
            color: Colors.white,
            size: 25,
          ),
        ),
        IconButton(
          onPressed: logout,
          icon: const Icon(
            Icons.logout_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      appBar: buildAppBar(),
      body: buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          if (index == 0) {
            searchController.clear();
            context.read<MovieProvider>().searchMovies('');
          }

          setState(() {
            selectedIndex = index;
            showSearch = false;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.visibility_outlined),
            selectedIcon: Icon(Icons.visibility),
            label: 'Watched',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Later',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle_outline),
            selectedIcon: Icon(Icons.play_circle),
            label: 'Watching',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}