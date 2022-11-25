import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weather_app/weather/weather.dart';
import 'current_weather_screen.dart' show WeatherBar;

//Виджет-экран с прогнозом погоды на 3 дня в городе
//название которого передано навигатором
class DailyWeatherScreenWidget extends StatelessWidget {
  const DailyWeatherScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final city = (ModalRoute.of(context)!.settings.arguments ?? "") as String;
    return BlocProvider<DailyWeatherCubit>(
      create: (context) {
        final cubit = DailyWeatherCubit();
        cubit.fetch(city);
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Погода в городе $city"),
        ),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: DailyWeatherWidget(),
          ),
        ),
      ),
    );
  }
}

class DailyWeatherWidget extends StatelessWidget {
  const DailyWeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DailyWeatherCubit, DailyWeather>(
      listener: (context, state) {
        if (state.status == WeatherStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Ошибка"),
            ),
          );
        }
      },
      child: BlocBuilder<DailyWeatherCubit, DailyWeather>(
        builder: (context, state) {
          if (state.status == WeatherStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == WeatherStatus.failure) {
            return const Center(
              child: Text("Ошибка получения данных"),
            );
          } else {
            return Column(
              children: [
                WeatherBar(weather: state.weather[0]),
                const SizedBox(
                  height: 20,
                ),
                WeatherBar(weather: state.weather[1]),
                const SizedBox(
                  height: 8,
                ),
                WeatherBar(weather: state.weather[2]),
              ],
            );
          }
        },
      ),
    );
  }
}
