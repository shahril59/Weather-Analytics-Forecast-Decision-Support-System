import 'package:flutter/material.dart';
import 'splashscreen.dart';
import 'homepage.dart';
import 'recommendation.dart';
import 'activitydetail.dart';
import 'profile.dart';
import 'screen/weather_screen.dart';
import 'screen/favorite_screen.dart';

void main() {
  runApp(const OutdoorActivityAdvisorApp());
}

class OutdoorActivityAdvisorApp extends StatelessWidget {
  const OutdoorActivityAdvisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TouchGrass',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32),
        scaffoldBackgroundColor: const Color(0xFF0A0F1A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A2E1A),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/recommendation': (context) => const RecommendationPage(),
        '/profile': (context) => const ProfilePage(),
        '/weather': (context) => const WeatherScreen(),
        '/favorites': (context) => const FavoritesPage(),
      },
    );
  }
}
