import 'package:flutter/material.dart';

import 'view/view.dart';
import 'routes.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.search,
      routes: {
        Routes.search: (context) => const SearchScreenWidget(),
        Routes.currentWeather: (context) => const CurrentWeatherScreenWidget(),
        Routes.dailyWeather: (context) => const DailyWeatherScreenWidget(),
      },
    );
  }
}
