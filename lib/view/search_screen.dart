import 'package:flutter/material.dart';

import 'package:weather_app/routes.dart';

//Виджет-экран с поиском города по названию
class SearchScreenWidget extends StatefulWidget {
  const SearchScreenWidget({super.key});

  @override
  State<SearchScreenWidget> createState() => _SearchScreenWidgetState();
}

class _SearchScreenWidgetState extends State<SearchScreenWidget> {
  final TextEditingController _controller = TextEditingController();
  String get _text => _controller.text;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Выберите город"),
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: "Город",
                  hintText: "Москва",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                    Routes.currentWeather,
                    arguments: _text,
                  ),
              icon: const Icon(Icons.search)),
        ],
      ),
    );
  }
}
