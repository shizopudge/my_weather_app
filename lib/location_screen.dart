import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/sqflite/sqflite_bloc.dart';
import 'package:my_weather_app/bloc/sqflite/sqflite_event.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/constants/font.dart';
import 'package:my_weather_app/widgets/location_widget.dart';
import 'bloc/location/location_bloc.dart';

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
    return BlocConsumer<LocationBloc, LocationState>(
      listenWhen: (previous, current) {
        return (previous.cityName != current.cityName);
      },
      listener: (context, state) {
        if (!state.isLoading) {
          context.read<WeatherBloc>().add(WeatherGetWeatherEvent());
          context.read<WeatherBloc>().add(
                WeatherGet24hWeatherEvent(),
              );
          context.read<WeatherBloc>().add(
                WeatherGetWeekWeatherEvent(),
              );
          if (state.isGeoDetermined) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Successfully added current location!',
                  textAlign: TextAlign.center,
                  style: Fonts.msgTextStyle.copyWith(fontSize: 14),
                ),
              ),
            );
          }
          if (state.isError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Sorry, probably something went wrong while we tried to determine your location...',
                  textAlign: TextAlign.center,
                  style: Fonts.msgTextStyle.copyWith(fontSize: 14),
                ),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        final cities = state.searchedCities ?? [];
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: state.isLoading ? false : true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        if (!state.isLoading)
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
                                          context.read<LocationBloc>().add(
                                                LocationSearchLocationEvent(
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
                                  context.read<LocationBloc>().add(
                                        LocationSearchLocationEvent(
                                          value,
                                        ),
                                      );
                                } else {
                                  context.read<LocationBloc>().add(
                                        LocationSearchLocationEvent(
                                          value,
                                        ),
                                      );
                                }
                              }),
                            ),
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
                                onPressed: () {
                                  context
                                      .read<LocationBloc>()
                                      .add(LocationGetCurrentLocationEvent());
                                },
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
                              color: Colors.grey.shade900,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListView.builder(
                                  itemCount: cities.length,
                                  itemBuilder: ((context, index) {
                                    final city = cities[index];
                                    return index == (cities.length - 1)
                                        ? InkWell(
                                            borderRadius:
                                                BorderRadius.circular(21),
                                            onTap: () {
                                              context.read<LocationBloc>().add(
                                                    LocationSetCityEvent(
                                                        city.countryName ?? '',
                                                        city.cityName ?? ''),
                                                  );
                                              context.read<SqfliteBloc>().add(
                                                    SqfliteOnSetLocationEvent(
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
                                                borderRadius:
                                                    BorderRadius.circular(21),
                                                onTap: () {
                                                  context
                                                      .read<LocationBloc>()
                                                      .add(LocationSetCityEvent(
                                                          city.countryName ??
                                                              '',
                                                          city.cityName ?? ''));
                                                  context
                                                      .read<SqfliteBloc>()
                                                      .add(
                                                        SqfliteOnSetLocationEvent(
                                                          city.cityName ?? '',
                                                          city.countryName ??
                                                              '',
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
          ),
        );
      },
    );
  }
}
