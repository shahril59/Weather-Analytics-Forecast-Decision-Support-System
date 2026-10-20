import 'package:flutter/material.dart';
import 'recommendation.dart';
import 'profile.dart';
import 'database/activity_database.dart';
import 'activitydetail.dart';
import 'model/activity_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const RecommendationPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Your Activity Advisor',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white54,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A2E1A),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white70),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          IconButton(
            icon: const Icon(Icons.cloud, color: Colors.white70),
            onPressed: () {
              Navigator.pushNamed(context, '/weather');
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [Color(0xFF0A0F1A), Color(0xFF05080F)],
          ),
        ),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.white38,
        backgroundColor: const Color(0xFF111B11),
        elevation: 0,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'Recommendation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> homeActivities = [
      {
        'title': 'Hiking',
        'icon': Icons.hiking,
        'image': 'assets/images/hiking.jpg',
        'description': 'Moderate • 2-4 hours',
        'color': const Color(0xFF4CAF50),
        'id': '5',
      },
      {
        'title': 'Camping',
        'icon': Icons.agriculture,
        'image': 'assets/images/camping.jpg',
        'description': 'Easy • Overnight',
        'color': const Color(0xFFFFA726),
        'id': '6',
      },
      {
        'title': 'Cycling',
        'icon': Icons.directions_bike,
        'image': 'assets/images/cycling.jpg',
        'description': 'Easy • 1-3 hours',
        'color': const Color(0xFF42A5F5),
        'id': '7',
      },
      {
        'title': 'Jogging',
        'icon': Icons.directions_run,
        'image': 'assets/images/jogging.jpg',
        'description': 'Intense • 30-60 min',
        'color': const Color(0xFFEF5350),
        'id': '8',
      },
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  '🌱 Popular Activities',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: homeActivities.length,
                  itemBuilder: (context, index) {
                    final activity = homeActivities[index];
                    return _buildActivityCard(
                      context,
                      activity['title'] as String,
                      activity['icon'] as IconData,
                      activity['image'] as String,
                      activity['description'] as String,
                      activity['color'] as Color,
                      activity['id'] as String,
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
      BuildContext context,
      String title,
      IconData icon,
      String imagePath,
      String description,
      Color color,
      String id,
      ) {
    return GestureDetector(
      onTap: () async {
        final dynamic result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ActivityDetailPage(
              activityTitle: title,
              activityIcon: icon,
              activityColor: color,
              activityDescription: description,
              activityId: id,
            ),
          ),
        );
        if (result == 'favorite') {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('🌿 $title added to favorites!'),
                backgroundColor: const Color(0xFF2E7D32),
              ),
            );
          }
        }
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFF1A2A1A),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: color.withOpacity(0.3),
                      child: Icon(icon, size: 50, color: color),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}