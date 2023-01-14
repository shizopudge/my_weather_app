import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_weather_app/bloc/location/location_bloc.dart';
import 'package:my_weather_app/bloc/sqflite/sqflite_bloc.dart';
import 'package:my_weather_app/bloc/sqflite/sqflite_event.dart';
import 'package:my_weather_app/bloc/sqflite/sqflite_state.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/constants/font.dart';

class EditLocationsScreen extends StatelessWidget {
  const EditLocationsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocConsumer<SqfliteBloc, SqfliteState>(
          listenWhen: ((previous, current) {
            return ((previous.isLoading != current.isLoading) &&
                !current.isLoading);
          }),
          listener: (context, state) {
            context.read<WeatherBloc>().add(WeatherGetWeatherEvent());
            context.read<WeatherBloc>().add(WeatherGet24hWeatherEvent());
            context.read<WeatherBloc>().add(
                  WeatherGetWeekWeatherEvent(),
                );
          },
          builder: (context, state) {
            final locations = state.locations ?? [];
            final favoriteLocations = state.favoriteLocations ?? [];
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          'Favorite location',
                          style: Fonts.msgTextStyle.copyWith(
                            fontSize: 20,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    if (favoriteLocations.isEmpty)
                      Text(
                        'No favorite location',
                        textAlign: TextAlign.center,
                        style: Fonts.msgTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    if (favoriteLocations.isNotEmpty)
                      ...favoriteLocations.map(
                        (location) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                            color: Colors.grey.shade900,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Spacer(),
                                  Column(
                                    children: [
                                      Text(
                                        location.city ?? '',
                                        textAlign: TextAlign.center,
                                        style: Fonts.headerTextStyle.copyWith(
                                            fontSize: 21, color: Colors.white),
                                      ),
                                      Text(
                                        location.country ?? '',
                                        textAlign: TextAlign.center,
                                        style: Fonts.msgTextStyle.copyWith(
                                            fontSize: 18,
                                            color: Colors.grey.shade500),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          'Another locations',
                          textAlign: TextAlign.center,
                          style: Fonts.msgTextStyle.copyWith(
                            fontSize: 20,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    if (locations.isEmpty)
                      Text(
                        'No locations',
                        textAlign: TextAlign.center,
                        style: Fonts.msgTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: locations.length,
                        itemBuilder: ((context, index) {
                          final location = locations[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    borderRadius: BorderRadius.circular(21),
                                    onPressed: (context) {
                                      context.read<SqfliteBloc>().add(
                                            SqfliteAddLocationToFavoriteEvent(
                                              location.city ?? '',
                                              location.country ?? '',
                                              location.id ?? 0,
                                            ),
                                          );
                                      context.read<LocationBloc>().add(
                                            LocationSetCityEvent(
                                                location.country ?? '',
                                                location.city ?? ''),
                                          );
                                    },
                                    backgroundColor: Colors.transparent,
                                    icon: Icons.favorite,
                                    foregroundColor: Colors.indigo,
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      context.read<SqfliteBloc>().add(
                                            SqfliteDeleteLocationEvent(
                                                location.id ?? 0),
                                          );
                                    },
                                    backgroundColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(21),
                                    icon: Icons.delete,
                                    foregroundColor: Colors.indigo,
                                  ),
                                ],
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                color: Colors.grey.shade900,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(),
                                      Column(
                                        children: [
                                          Text(
                                            location.city ?? '',
                                            textAlign: TextAlign.center,
                                            style: Fonts.headerTextStyle
                                                .copyWith(
                                                    fontSize: 21,
                                                    color: Colors.white),
                                          ),
                                          Text(
                                            location.country ?? '',
                                            textAlign: TextAlign.center,
                                            style: Fonts.msgTextStyle.copyWith(
                                                fontSize: 18,
                                                color: Colors.grey.shade500),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                        color: Colors.indigo,
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
              );
            }
          },
        ),
      ),
    );
  }
}
