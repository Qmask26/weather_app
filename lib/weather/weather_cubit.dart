import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'weather_model.dart';
import 'weather_api.dart';

class CurrentWeatherCubit extends Cubit<Weather> {
  //Объект-api для доступа к прогнозам погоды
  final _weatherApi = WeatherApi();

  CurrentWeatherCubit() : super(const Weather.empty());

  //метод, извлекающий с помощью api погоду в городе [city]
  //в настоящий момент времени
  Future<void> fetch(String city) async {
    emit(state.copyWith(status: WeatherStatus.loading));
    emit(await _weatherApi.getCurrentWeather(city));
  }
}

class DailyWeatherCubit extends Cubit<DailyWeather> {
  //Объект-api для доступа к прогнозам погоды
  final _weatherApi = WeatherApi();

  DailyWeatherCubit() : super(DailyWeather.empty());

  //метод, извлекающий с помощью api прогноз погоды на 3 дня в городе [city]
  Future<void> fetch(String city) async {
    emit(state.copyWith(status: WeatherStatus.loading));
    emit(await _weatherApi.getDailyWeather(city));
  }
}
