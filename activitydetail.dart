import 'package:flutter/material.dart';
import 'database/activity_database.dart';

class ActivityDetailPage extends StatelessWidget {
  final String activityTitle;
  final IconData activityIcon;
  final Color activityColor;
  final String activityDescription;
  final String? activityId;

  const ActivityDetailPage({
    super.key,
    required this.activityTitle,
    required this.activityIcon,
    required this.activityColor,
    required this.activityDescription,
    this.activityId,
  });

  String _getImagePath() {
    String title = activityTitle.toLowerCase();

    // HOMEPAGE ACTIVITIES
    if (title == 'hiking') return 'assets/images/hiking.jpg';
    if (title == 'camping') return 'assets/images/camping.jpg';
    if (title == 'cycling') return 'assets/images/cycling.jpg';
    if (title == 'jogging') return 'assets/images/jogging.jpg';

    // RECOMMENDATION ACTIVITIES
    if (title.contains('bukit saga')) return 'assets/images/bukit_saga.jpg';
    if (title.contains('taman negara')) return 'assets/images/taman_negara.jpeg';
    if (title.contains('putrajaya')) return 'assets/images/putrajaya.jpg';
    if (title.contains('templer park')) return 'assets/images/templer_park.jpg';
    return 'assets/images/hiking.jpg';
  }

  void _toggleFavorite(BuildContext context) async {
    String? id = activityId;

    if (id == null) {
      final allActivities = ActivityDatabase.getAllActivities();
      for (var activity in allActivities) {
        if (activity.title == activityTitle) {
          id = activity.id;
          break;
        }
      }
    }

    if (id != null) {
      await ActivityDatabase.toggleFavorite(id);

      final favorites = await ActivityDatabase.getFavoriteIds();
      final isNowFavorite = favorites.contains(id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              isNowFavorite
                  ? '🌿 $activityTitle added to favorites!'
                  : 'Removed from favorites'
          ),
          backgroundColor: isNowFavorite ? const Color(0xFF2E7D32) : Colors.red,
        ),
      );

      Navigator.pop(context, 'favorite');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Activity not found!'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1A),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'TouchGrass',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Your Activity Advisor',
              style: TextStyle(
                fontSize: 9,
                color: Colors.white54,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A2E1A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1A3A1A),
                  activityColor.withOpacity(0.6),
                  const Color(0xFF1A3A1A),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Image.asset(
                _getImagePath(),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 280,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(activityIcon, size: 80, color: Colors.white54),
                  );
                },
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activityTitle,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: activityColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: activityColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      activityDescription,
                      style: TextStyle(color: activityColor, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Activity Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'This outdoor activity is perfect for nature enthusiasts. '
                        'Make sure to bring appropriate gear and follow safety guidelines.',
                    style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'What to Bring:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const BulletPoint(text: '🌿 Comfortable sportswear'),
                  const BulletPoint(text: '💧 Water bottle (at least 1L)'),
                  const BulletPoint(text: '🍎 Energy snacks'),
                  const BulletPoint(text: '☀️ Sunscreen and hat'),
                  const BulletPoint(text: '🩹 First aid kit'),
                  const SizedBox(height: 24),

                  const Text(
                    'Safety Tips:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const BulletPoint(text: '🌤️ Check weather forecast'),
                  const BulletPoint(text: '📱 Inform someone about your plan'),
                  const BulletPoint(text: '🚶 Stay on designated trails'),
                  const BulletPoint(text: '🔋 Carry a fully charged phone'),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _toggleFavorite(context),
                          icon: const Icon(Icons.favorite),
                          label: const Text('Save to Favorites'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white10,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(color: Colors.white24),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15, color: Colors.white70))),
        ],
      ),
    );
  }
}