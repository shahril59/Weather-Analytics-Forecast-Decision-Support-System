import 'package:flutter/material.dart';
import '../database/activity_database.dart';
import '../activitydetail.dart';
import '../model/activity_model.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<ActivityModel> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });
    final favorites = await ActivityDatabase.getFavoriteActivities();
    setState(() {
      _favorites = favorites;
      _isLoading = false;
    });
  }

  Future<void> _removeFromFavorites(String id) async {
    await ActivityDatabase.toggleFavorite(id);
    await _loadFavorites();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from favorites'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _clearAllFavorites() async {
    await ActivityDatabase.clearAllFavorites();
    await _loadFavorites();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All favorites cleared'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  IconData _getIconForActivity(String title) {
    if (title.contains('Hiking') || title.contains('Bukit')) return Icons.hiking;
    if (title.contains('Taman Negara')) return Icons.agriculture;
    if (title.contains('Cycling') || title.contains('Putrajaya')) return Icons.directions_bike;
    if (title.contains('Jogging') || title.contains('Templer')) return Icons.directions_run;
    return Icons.fitness_center;
  }

  Color _getColorForActivity(String title) {
    if (title.contains('Hiking') || title.contains('Bukit')) return const Color(0xFF4CAF50);
    if (title.contains('Taman Negara')) return const Color(0xFFFFA726);
    if (title.contains('Cycling') || title.contains('Putrajaya')) return const Color(0xFF42A5F5);
    if (title.contains('Jogging') || title.contains('Templer')) return const Color(0xFFEF5350);
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1A),
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1A2E1A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          if (_favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.white54),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    backgroundColor: const Color(0xFF1A2A1A),
                    title: const Text(
                      'Clear All Favorites',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      'Are you sure you want to remove all favorites?',
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _clearAllFavorites();
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
        ),
      )
          : _favorites.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.favorite_border, size: 80, color: Colors.white24),
            SizedBox(height: 20),
            Text(
              '🌿 No favorites yet',
              style: TextStyle(fontSize: 18, color: Colors.white54),
            ),
            SizedBox(height: 8),
            Text(
              'Go to activities and save your favorites!',
              style: TextStyle(fontSize: 14, color: Colors.white24),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _favorites.length,
        itemBuilder: (BuildContext context, int index) {
          final ActivityModel activity = _favorites[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: const Color(0xFF1A2A1A),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  activity.imagePath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image, size: 40, color: Colors.white24),
                ),
              ),
              title: Text(
                activity.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Location: ${activity.location}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  Text(
                    'Difficulty: ${activity.difficulty}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () => _removeFromFavorites(activity.id),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ActivityDetailPage(
                      activityTitle: activity.title,
                      activityIcon: _getIconForActivity(activity.title),
                      activityColor: _getColorForActivity(activity.title),
                      activityDescription: '${activity.location} - ${activity.description}',
                      activityId: activity.id,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}