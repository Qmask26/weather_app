import 'package:http/http.dart';
import 'dart:convert';

import 'weather_model.dart';

class WeatherRequestFailure implements Exception {}

class WeatherApi {
  final Client _httpClient = Client();
  static const _key = "91f335d4e2e8619b5e276940b64d663f";
  static const _currentWeatherUrl =
      "https://api.openweathermap.org/data/2.5/weather";
  static const _dailyWeatherUrl =
      "http://api.openweathermap.org/data/2.5/forecast/daily";

  Future<Weather> getCurrentWeather(String city) async {
    final request = Uri.https(
      _currentWeatherUrl,
      "",
      {
        'q': city,
        'appid': _key,
      },
    );
    final response = await _httpClient.get(request);

    if (response.statusCode != 200) {
      throw WeatherRequestFailure();
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (!body.containsKey('weather')) {
      throw WeatherRequestFailure();
    }

    return Weather.fromJson(body);
  }
}
