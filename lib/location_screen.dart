import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/city/city_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/constants/font.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocConsumer<CityBloc, CityState>(listenWhen: (previous, current) {
        return (previous.cityName != current.cityName);
      }, listener: (context, state) {
        if (!state.isLoading) {
          context.read<WeatherBloc>().add(WeatherGetWeatherEvent());
        }
      }, builder: (context, state) {
        final cities = state.searchedCities ?? [];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: ((value) {
                      if (value.isNotEmpty) {
                        context.read<CityBloc>().add(
                              CitySearchLocationEvent(
                                value,
                              ),
                            );
                      } else {
                        context.read<CityBloc>().add(
                              CitySearchLocationEvent(
                                value,
                              ),
                            );
                      }
                    }),
                  ),
                ),
                if (state.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                if (!state.isLoading &&
                    cities.isEmpty &&
                    _searchController.text.isNotEmpty)
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/cloud.png',
                        height: 120,
                      ),
                      const Text(
                        'Nothing found...',
                        textAlign: TextAlign.center,
                        style: Fonts.msgTextStyle,
                      )
                    ],
                  ),
                if (!state.isLoading && _searchController.text.isEmpty)
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/cloud.png',
                        height: 120,
                      ),
                      const Text(
                        'Enter location name.',
                        textAlign: TextAlign.center,
                        style: Fonts.msgTextStyle,
                      )
                    ],
                  ),
                if (!state.isLoading &&
                    cities.isNotEmpty &&
                    _searchController.text.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: cities.length,
                      itemBuilder: ((context, index) {
                        final city = cities[index];
                        return InkWell(
                          onTap: () {
                            context.read<CityBloc>().add(CitySetCityEvent(
                                city.countryName ?? '', city.cityName ?? ''));
                            Navigator.pop(context);
                          },
                          child: Card(
                            color: Colors.blue,
                            elevation: 16,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      city.cityName.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                      ),
                                    ),
                                    Text(
                                      city.countryName.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
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
      }),
    );
  }
}
