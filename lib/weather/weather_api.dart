import 'package:http/http.dart';
import 'dart:convert';

import 'weather_model.dart';

class WeatherRequestFailure implements Exception {}

class WeatherApi {
  static const _key = ""; //Ключ api (https://openweathermap.org/)
  static const _currentWeatherUrl =
      "https://api.openweathermap.org/data/2.5/weather"; //url для получения погоды на текущий момент
  static const _dailyWeatherUrl =
      "https://api.openweathermap.org/data/2.5/forecast"; //url для получения прогноза погоды на 5 дней

  //Метод, возвращающий текущую погоду города [city]
  Future<Weather> getCurrentWeather(String city) async {
    final response = await get(
      Uri.parse("$_currentWeatherUrl?q=$city&appid=$_key"),
    );

    if (response.statusCode != 200) {
      //если обращение к api завершилось неудачно, то возвращаем [Weather] со статусом ошибки
      return const Weather.empty().copyWith(status: WeatherStatus.failure);
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (!body.containsKey('weather')) {
      //если json-ответ не соответсвует тому формату, который мы ожидаем, то возвращаем
      //объект [Weather] со статусом ошибки
      return const Weather.empty().copyWith(status: WeatherStatus.failure);
    }
    return Weather.fromJson(body);
  }

  Future<DailyWeather> getDailyWeather(String city) async {
    final response = await get(
      Uri.parse("$_dailyWeatherUrl?q=$city&appid=$_key"),
    );
    if (response.statusCode != 200) {
      //если обращение к api завершилось неудачно, то возвращаем [Weather] со статусом ошибки
      return DailyWeather.empty().copyWith(status: WeatherStatus.failure);
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (!body.containsKey('list')) {
      return DailyWeather.empty().copyWith(status: WeatherStatus.failure);
    }

    //список с прогнозом погоды, который будет в объекте, возвраемом функцией
    final List<Weather> result = [];

    //добавляем в список прогнозы погоды на 3 дня
    //т.к. api возвращает прогноз погоды соответствующие временным отметкам
    //с разностью в 3 часа, то берем прогнозы на 12:00 каждого дня
    for (final element in body['list']) {
      if (!element.containsKey('weather')) {
        //если json-ответ не соответсвует тому формату, который мы ожидаем, то возвращаем
        //объект [Weather] со статусом ошибки
        return DailyWeather.empty().copyWith(status: WeatherStatus.failure);
      }
      if ((element['dt_txt'] as String).contains("12:00:00") &&
          result.length < 3) {
        result.add(Weather.fromJson(element));
      }
    }

    //меняем порядок в результирующем списке так,
    //чтобы первым шел прогноз с самой низкой температурой
    if (result[1].temp < result[0].temp) {
      result.insert(0, result[1]);
      result.removeAt(2);
    }

    if (result[2].temp < result[0].temp) {
      result.insert(0, result[2]);
      result.removeAt(3);
    }

    return DailyWeather(
      status: WeatherStatus.success,
      weather: result,
    );
  }
}
