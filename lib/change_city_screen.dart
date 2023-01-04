import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/city/city_bloc.dart';
import 'package:my_weather_app/bloc/city/city_event.dart';
import 'package:my_weather_app/bloc/city/city_state.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';

class ChangeCityScreen extends StatefulWidget {
  final List finalCities;
  final String country;
  const ChangeCityScreen({
    super.key,
    required this.finalCities,
    required this.country,
  });

  @override
  State<ChangeCityScreen> createState() => _ChangeCityScreenState();
}

class _ChangeCityScreenState extends State<ChangeCityScreen> {
  final TextEditingController _cityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cityBloc = BlocProvider.of<CityBloc>(context);
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    return Scaffold(
      body: BlocBuilder<CityBloc, CityState>(
        builder: (context, state) {
          final cities = state.cities;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'City',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: ((value) {
                        if (value.length >= 2) {
                          cityBloc.add(
                            CitySearchCititesEvent(
                              value,
                              widget.finalCities,
                              state.countryName ?? '',
                            ),
                          );
                        } else if (value.isEmpty) {
                          cityBloc.add(
                            CityGetCititesEvent(
                              widget.finalCities,
                              state.countryName ?? '',
                            ),
                          );
                        } else {
                          return;
                        }
                      }),
                    ),
                  ),
                  Text(state.countryName ?? ''),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cities.length,
                      itemBuilder: ((context, index) {
                        final city = cities[index];
                        return GestureDetector(
                          onTap: () {
                            cityBloc.add(
                              CitySetCityEvent(
                                widget.country,
                                city,
                              ),
                            );
                            weatherBloc.add(WeatherGetWeatherEvent());
                          },
                          child: Card(
                            color: Colors.blue,
                            elevation: 16,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  city.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
