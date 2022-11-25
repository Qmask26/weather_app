class Weather {
  final double temp, humidity, windSpeed;
  const Weather(
      {required this.temp, required this.humidity, required this.windSpeed});

  Weather.fromJson(Map<String, dynamic> json)
      : temp = json['main']['temp'],
        humidity = json['main']['humidity'],
        windSpeed = json['wind']['speed'];
}
