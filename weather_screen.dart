import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../model/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _cityController = TextEditingController();

  WeatherModel? _weather;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _fetchWeather() async {
    if (_cityController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city name';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final weather = await _weatherService.getWeather(_cityController.text);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Enter city name',
                      labelStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    ),
                    onSubmitted: (_) => _fetchWeather(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _fetchWeather,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Search'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (_errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red[300]),
                ),
              ),

            if (_isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                  ),
                ),
              ),

            if (_weather != null && !_isLoading)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: const Color(0xFF1A2A1A),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                _weather!.cityName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Image.network(
                                _weather!.weatherIconUrl,
                                width: 100,
                                height: 100,
                                errorBuilder: (_, __, ___) =>
                                const Icon(Icons.cloud, size: 80, color: Colors.white54),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _weather!.temperatureDisplay,
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                              Text(
                                _weather!.description.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white54,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildWeatherInfo(
                                    Icons.thermostat,
                                    'Feels Like',
                                    _weather!.feelsLikeDisplay,
                                  ),
                                  _buildWeatherInfo(
                                    Icons.water_drop,
                                    'Humidity',
                                    '${_weather!.humidity}%',
                                  ),
                                  _buildWeatherInfo(
                                    Icons.air,
                                    'Wind Speed',
                                    '${_weather!.windSpeed} km/h',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [const Color(0xFF1A2E1A), const Color(0xFF2E7D32).withOpacity(0.2)],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '🌿 Activity Suggestion',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _getActivitySuggestion(_weather!),
                              style: const TextStyle(fontSize: 16, color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
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

  Widget _buildWeatherInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white54),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white38),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  String _getActivitySuggestion(WeatherModel weather) {
    final temp = weather.temperature;
    final description = weather.description.toLowerCase();

    if (temp > 25 && description.contains('clear')) {
      return '☀️ Perfect weather for HIKING or CYCLING!';
    } else if (temp > 20 && temp <= 25) {
      return '🌤️ Great day for JOGGING or a short HIKE!';
    } else if (temp > 15 && temp <= 20) {
      return '🌥️ Good weather for CAMPING, bring a jacket!';
    } else if (temp <= 15) {
      return '❄️ Cold weather - stay indoors or do indoor activities!';
    } else if (description.contains('rain')) {
      return '☔ Rainy day - better to stay indoors!';
    } else {
      return 'Check the weather and plan your outdoor activity!';
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}