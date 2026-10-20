import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather_model.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static const String _apiKey = 'd1c26ed2dc2cd1f7efbb540bfe7489d6';

  Future<WeatherModel> getWeather(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?q=$city&appid=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}