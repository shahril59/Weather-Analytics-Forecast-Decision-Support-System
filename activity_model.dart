class ActivityModel {
  final String id;
  final String title;
  final String difficulty;
  final String duration;
  final String location;
  final String description;
  final bool isFavorite;
  final String imagePath;
  final DateTime createdAt;

  ActivityModel({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.duration,
    required this.location,
    required this.description,
    this.isFavorite = false,
    required this.imagePath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  ActivityModel copyWith({
    String? id,
    String? title,
    String? difficulty,
    String? duration,
    String? location,
    String? description,
    bool? isFavorite,
    String? imagePath,
    DateTime? createdAt,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      difficulty: difficulty ?? this.difficulty,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}