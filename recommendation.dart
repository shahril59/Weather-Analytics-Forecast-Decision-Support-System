import 'package:flutter/material.dart';
import 'database/activity_database.dart';
import 'activitydetail.dart';
import 'model/activity_model.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  String _selectedDifficulty = 'All';
  String _selectedDuration = 'All';
  String _recommendationResult = '';

  final List<String> _difficulties = <String>['All', 'Easy', 'Moderate', 'Intense'];
  final List<String> _durations = <String>[
    'All',
    '30-60 min',
    '1-3 hours',
    '2-4 hours',
    'Overnight'
  ];

  // SHOW ONLY RECOMMENDATION ACTIVITIES (IDs 1-4)
  List<ActivityModel> get _recommendationActivities {
    final List<ActivityModel> allActivities = ActivityDatabase.getAllActivities();
    return allActivities.where((ActivityModel activity) {
      final id = int.tryParse(activity.id) ?? 0;
      return id >= 1 && id <= 4;
    }).toList();
  }

  List<ActivityModel> get _filteredActivities {
    return _recommendationActivities.where((ActivityModel activity) {
      if (_selectedDifficulty != 'All' &&
          activity.difficulty != _selectedDifficulty) {
        return false;
      }
      if (_selectedDuration != 'All' &&
          activity.duration != _selectedDuration) {
        return false;
      }
      return true;
    }).toList();
  }

  void _getRecommendation() {
    setState(() {
      if (_filteredActivities.isEmpty) {
        _recommendationResult =
        'No activities match your preferences. Try different filters!';
      } else {
        _recommendationResult =
        '🌿 Found ${_filteredActivities.length} activity(s) matching your preferences!';
      }
    });
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
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [Color(0xFF0A0F1A), Color(0xFF05080F)],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF1A2E1A), const Color(0xFF2E7D32).withOpacity(0.3)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
              ),
              child: Column(
                children: <Widget>[
                  const Row(
                    children: <Widget>[
                      Icon(Icons.recommend, color: Color(0xFF4CAF50)),
                      SizedBox(width: 10),
                      Text(
                        '🌿 Get Your Activity Recommendation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Difficulty Level',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.trending_up),
                      labelStyle: TextStyle(color: Colors.white54),
                    ),
                    style: const TextStyle(color: Colors.white),
                    value: _selectedDifficulty,
                    items: _difficulties.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDifficulty = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Duration',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.timer),
                      labelStyle: TextStyle(color: Colors.white54),
                    ),
                    style: const TextStyle(color: Colors.white),
                    value: _selectedDuration,
                    items: _durations.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDuration = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _getRecommendation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Get Recommendations'),
                    ),
                  ),
                  if (_recommendationResult.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text(
                          _recommendationResult,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4CAF50),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '🌿 Recommendations for You',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            _filteredActivities.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  'No activities found. Adjust your filters.',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredActivities.length,
              itemBuilder: (BuildContext context, int index) {
                final ActivityModel activity = _filteredActivities[index];
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
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(_getIconForActivity(activity.title), size: 30, color: _getColorForActivity(activity.title)),
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
                          'Difficulty: ${activity.difficulty}',
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        Text(
                          'Duration: ${activity.duration}',
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        Text(
                          'Location: ${activity.location}',
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF4CAF50),
                    ),
                    onTap: () async {
                      final dynamic result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ActivityDetailPage(
                            activityTitle: activity.title,
                            activityIcon: _getIconForActivity(activity.title),
                            activityColor: _getColorForActivity(activity.title),
                            activityDescription:
                            '${activity.location} - ${activity.description}',
                            activityId: activity.id,
                          ),
                        ),
                      );
                      if (result == 'favorite') {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('🌿 ${activity.title} saved!'),
                              backgroundColor: const Color(0xFF2E7D32),
                            ),
                          );
                        }
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}