import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/city/city_bloc.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/bloc/locations/locations_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/constants/font.dart';
import 'package:my_weather_app/widgets/location_widget.dart';

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
    final theme =
        context.select<LocalBloc, String>((value) => value.state.theme);
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
          context.read<WeatherBloc>().add(
                WeatherGet24hWeatherEvent(),
              );
          context.read<WeatherBloc>().add(
                WeatherGetWeekWeatherEvent(),
              );
          context.read<LocationsBloc>().add(LocationsGetLocationsEvent());
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
                    style: Fonts.msgTextStyle.copyWith(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      suffixIcon: _searchController.text.isNotEmpty
                          ? InkWell(
                              radius: 24,
                              borderRadius: BorderRadius.circular(21),
                              onTap: () {
                                _searchController.clear();
                                context.read<CityBloc>().add(
                                      CitySearchLocationEvent(
                                        '',
                                      ),
                                    );
                              },
                              child: const Icon(
                                Icons.cancel_sharp,
                                color: Colors.white,
                              ),
                            )
                          : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      hintText: 'Search',
                      hintStyle: Fonts.msgTextStyle.copyWith(
                        color: Colors.white,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
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
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Add current loaction',
                          style: Fonts.msgTextStyle,
                        ),
                      ),
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
                    child: Card(
                      color: theme == 'dark'
                          ? Colors.grey.shade900
                          : Colors.grey.shade300,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.builder(
                          itemCount: cities.length,
                          itemBuilder: ((context, index) {
                            final city = cities[index];
                            return index == (cities.length - 1)
                                ? InkWell(
                                    borderRadius: BorderRadius.circular(21),
                                    onTap: () {
                                      context.read<CityBloc>().add(
                                            CitySetCityEvent(
                                                city.countryName ?? '',
                                                city.cityName ?? ''),
                                          );
                                      context.read<LocationsBloc>().add(
                                            LocationsOnSetLocationEvent(
                                              city.cityName ?? '',
                                              city.countryName ?? '',
                                            ),
                                          );
                                      Navigator.pop(context);
                                    },
                                    child: LocationWidget(
                                      city: city,
                                    ),
                                  )
                                : Column(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(21),
                                        onTap: () {
                                          context.read<CityBloc>().add(
                                              CitySetCityEvent(
                                                  city.countryName ?? '',
                                                  city.cityName ?? ''));
                                          context.read<LocationsBloc>().add(
                                                LocationsOnSetLocationEvent(
                                                  city.cityName ?? '',
                                                  city.countryName ?? '',
                                                ),
                                              );
                                          Navigator.pop(context);
                                        },
                                        child: LocationWidget(
                                          city: city,
                                        ),
                                      ),
                                      const Divider(
                                        thickness: 1.5,
                                      ),
                                    ],
                                  );
                          }),
                        ),
                      ),
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
