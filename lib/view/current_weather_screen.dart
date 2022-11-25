import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weather_app/weather/weather.dart';
import 'package:weather_app/routes.dart';

//Виджет-экран с информацией о погоде в текущий момент времени в городе
//название которого передано навигатором
class CurrentWeatherScreenWidget extends StatelessWidget {
  const CurrentWeatherScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final city = (ModalRoute.of(context)!.settings.arguments ?? "") as String;
    return BlocProvider<CurrentWeatherCubit>(
      create: (context) {
        final cubit = CurrentWeatherCubit();
        cubit.fetch(city);
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Погода сейчас"),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(Routes.search),
              icon: const Icon(Icons.search),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed(Routes.dailyWeather, arguments: city),
              child: const Text("3 дня"),
            ),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: WeatherWidget(),
          ),
        ),
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentWeatherCubit, Weather>(
      listener: (context, state) {
        if (state.status == WeatherStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Ошибка"),
            ),
          );
        }
      },
      child: BlocBuilder<CurrentWeatherCubit, Weather>(
        builder: (context, state) {
          if (state.status == WeatherStatus.success) {
            return WeatherBar(weather: state);
          } else if (state.status == WeatherStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: Text("Ошибка получения данных"),
            );
          }
        },
      ),
    );
  }
}

//Виджет отображающий блок с погодой в определенную дату
class WeatherBar extends StatelessWidget {
  final Weather weather;
  const WeatherBar({
    Key? key,
    required this.weather,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(31, 0, 0, 0),
            blurRadius: 12,
            //spreadRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              weather.date,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Text(
              "Температура, ℃",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              (weather.temp - 273.15).toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text("Скорость ветра, м/с"),
                    Text(weather.windSpeed.toString()),
                  ],
                ),
                Column(
                  children: [
                    const Text("Влажность, %"),
                    Text(weather.humidity.toString()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
