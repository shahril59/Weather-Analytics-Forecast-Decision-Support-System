class WeatherModel {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final DateTime lastUpdated;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.lastUpdated,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? 'Unknown',
      temperature: (json['main']['temp'] as num).toDouble() - 273.15,
      feelsLike: (json['main']['feels_like'] as num).toDouble() - 273.15,
      description: json['weather'][0]['description'] ?? 'No description',
      iconCode: json['weather'][0]['icon'] ?? '01d',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      lastUpdated: DateTime.now(),
    );
  }

  String get weatherIconUrl =>
      'https://openweathermap.org/img/wn/$iconCode@2x.png';

  String get temperatureDisplay => '${temperature.toStringAsFixed(1)}°C';

  String get feelsLikeDisplay => '${feelsLike.toStringAsFixed(1)}°C';
}