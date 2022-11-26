import 'package:equatable/equatable.dart';

//состояния, в которых могут находится объекты классов [Weather] и [DailyWeather]
enum WeatherStatus {
  //объект загружается из репозитория
  loading,
  //объект успешно загружен
  success,
  //произошла ошибка загрузки
  failure,
  //объект пуст
  empty,
}

//класс-контейнер, хранящий прогноз погоды [Weather] на 3 дня
class DailyWeather extends Equatable {
  final WeatherStatus status;
  final List<Weather> weather;
  const DailyWeather({required this.status, required this.weather});

  DailyWeather.empty()
      : status = WeatherStatus.empty,
        weather = [];

  @override
  List<Object> get props => [status, weather];

  DailyWeather copyWith({
    List<Weather>? weather,
    WeatherStatus? status,
  }) {
    return DailyWeather(
        status: status ?? this.status, weather: weather ?? this.weather);
  }
}

//Прогноз погоды соответствующий дате [date]
class Weather extends Equatable {
  final WeatherStatus status;
  //температура(в Кельвинах, при отображении переводится в градусы Цельсия), влажность (%), скорость ветра (м/с)
  final double temp, humidity, windSpeed;
  //дата, которой соответствует прогноз в формате строки (гггг-мм-дд чч:мм:сс)
  final String date;

  const Weather({
    required this.status,
    required this.temp,
    required this.humidity,
    required this.windSpeed,
    required this.date,
  });

  const Weather.empty()
      : temp = 0,
        humidity = 0,
        windSpeed = 0,
        date = "",
        status = WeatherStatus.empty;

  Weather.fromJson(Map<String, dynamic> json)
      : temp = json['main']['temp'] + 0.0,
        humidity = json['main']['humidity'] + 0.0,
        windSpeed = json['wind']['speed'] + 0.0,
        date = json['dt_txt'] ?? "Сейчас",
        status = WeatherStatus.success;

  Weather copyWith({
    double? temp,
    double? humidity,
    double? windSpeed,
    String? date,
    WeatherStatus? status,
  }) {
    return Weather(
      temp: temp ?? this.temp,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }

  @override
  List<Object> get props => [status, temp, humidity, windSpeed, date];
}
