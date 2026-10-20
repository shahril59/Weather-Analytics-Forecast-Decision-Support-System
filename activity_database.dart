import 'package:shared_preferences/shared_preferences.dart';
import '../model/activity_model.dart';

class ActivityDatabase {
  static List<ActivityModel> _activities = [];
  static const String _favoritesKey = 'favorites_list';

  static void seedDefaultActivities() {
    if (_activities.isEmpty) {
      _activities = [
        // RECOMMENDATION ACTIVITIES (IDs 1-4) - USE THEIR OWN IMAGES
        ActivityModel(
          id: '1',
          title: 'Bukit Saga Hiking',
          difficulty: 'Moderate',
          duration: '2-4 hours',
          location: 'Kuala Lumpur',
          description: 'Beautiful morning hike with stunning city views',
          imagePath: 'assets/images/bukit_saga.jpg',
        ),
        ActivityModel(
          id: '2',
          title: 'Taman Negara',
          difficulty: 'Easy',
          duration: 'Overnight',
          location: 'Pahang',
          description: 'Experience the oldest rainforest in the world',
          imagePath: 'assets/images/taman_negara.jpeg',
        ),
        ActivityModel(
          id: '3',
          title: 'Putrajaya Cycling',
          difficulty: 'Easy',
          duration: '1-3 hours',
          location: 'Putrajaya',
          description: 'Scenic cycling route around Putrajaya lake',
          imagePath: 'assets/images/putrajaya.jpg',
        ),
        ActivityModel(
          id: '4',
          title: 'Templer Park Jogging',
          difficulty: 'Intense',
          duration: '30-60 min',
          location: 'Rawang',
          description: 'Challenging trail run with waterfall views',
          imagePath: 'assets/images/templer_park.jpg',
        ),

        // HOMEPAGE ACTIVITIES (IDs 5-8) - USE THEIR OWN IMAGES
        ActivityModel(
          id: '5',
          title: 'Hiking',
          difficulty: 'Moderate',
          duration: '2-4 hours',
          location: 'Kuala Lumpur',
          description: 'Beautiful morning hike with stunning city views',
          imagePath: 'assets/images/hiking.jpg',
        ),
        ActivityModel(
          id: '6',
          title: 'Camping',
          difficulty: 'Easy',
          duration: 'Overnight',
          location: 'Pahang',
          description: 'Experience the oldest rainforest in the world',
          imagePath: 'assets/images/camping.jpg',
        ),
        ActivityModel(
          id: '7',
          title: 'Cycling',
          difficulty: 'Easy',
          duration: '1-3 hours',
          location: 'Putrajaya',
          description: 'Scenic cycling route around Putrajaya lake',
          imagePath: 'assets/images/cycling.jpg',
        ),
        ActivityModel(
          id: '8',
          title: 'Jogging',
          difficulty: 'Intense',
          duration: '30-60 min',
          location: 'Rawang',
          description: 'Challenging trail run with waterfall views',
          imagePath: 'assets/images/jogging.jpg',
        ),
      ];
    }
  }

  static List<ActivityModel> getAllActivities() {
    seedDefaultActivities();
    return _activities;
  }

  static Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }

    await prefs.setStringList(_favoritesKey, favorites);
  }

  static Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  static Future<List<ActivityModel>> getFavoriteActivities() async {
    final ids = await getFavoriteIds();
    return _activities.where((activity) => ids.contains(activity.id)).toList();
  }

  static Future<void> clearAllFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }
}