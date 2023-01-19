import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/bloc/location/location_bloc.dart';
import 'package:my_weather_app/bloc/settings/settings_bloc.dart';
import 'package:my_weather_app/bloc/sqflite/sqflite_bloc.dart';
import 'package:my_weather_app/bloc/sqflite/sqflite_state.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/constants/font.dart';
import 'package:my_weather_app/edit_locations_screen.dart';
import 'package:my_weather_app/settings_screen.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme =
        context.select<LocalBloc, String>((value) => value.state.theme);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(21),
              bottomRight: Radius.circular(21),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          radius: 100,
                          borderRadius: BorderRadius.circular(21),
                          onTap: () {
                            context.read<LocalBloc>().add(
                                  LocalSetThemeStateEvent(
                                      theme == 'light' ? 'dark' : 'light'),
                                );
                          },
                          child: theme == 'light'
                              ? const Icon(
                                  Icons.sunny,
                                  size: 32,
                                  color: Colors.indigo,
                                )
                              : const Icon(
                                  Icons.nightlight,
                                  size: 32,
                                  color: Colors.indigo,
                                ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                            Scaffold.of(context).closeDrawer();
                          },
                          radius: 100,
                          borderRadius: BorderRadius.circular(21),
                          child: const Icon(
                            Icons.settings,
                            size: 32,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: BlocBuilder<SettingsBloc, SettingsState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                const Text(
                                  'Units',
                                  style: Fonts.headerTextStyle,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: ToggleButtons(
                                    onPressed: ((index) {
                                      switch (index) {
                                        case 0:
                                          const String units = 'metric';
                                          context.read<SettingsBloc>().add(
                                                SettingsChangeUnitsEvent(
                                                    index, units),
                                              );
                                          context.read<WeatherBloc>().add(
                                                WeatherGetWeatherEvent(),
                                              );
                                          context.read<WeatherBloc>().add(
                                                WeatherGet24hWeatherEvent(),
                                              );
                                          context.read<WeatherBloc>().add(
                                                WeatherGetWeekWeatherEvent(),
                                              );
                                          break;
                                        case 1:
                                          const String units = 'imperial';
                                          context.read<SettingsBloc>().add(
                                                SettingsChangeUnitsEvent(
                                                    index, units),
                                              );
                                          context.read<WeatherBloc>().add(
                                                WeatherGetWeatherEvent(),
                                              );
                                          context.read<WeatherBloc>().add(
                                                WeatherGet24hWeatherEvent(),
                                              );
                                          context.read<WeatherBloc>().add(
                                                WeatherGetWeekWeatherEvent(),
                                              );
                                          break;
                                        default:
                                      }
                                    }),
                                    isSelected: state.selections,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'assets/icons/celsius.png',
                                          height: 50,
                                          color: theme == 'dark'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'assets/icons/fahrenheit.png',
                                          height: 50,
                                          color: theme == 'dark'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  BlocBuilder<SqfliteBloc, SqfliteState>(
                    builder: ((context, state) {
                      final locations = state.locations ?? [];
                      final favoriteLocations = state.favoriteLocations ?? [];
                      if (state.isLoading) {
                        return const CircularProgressIndicator(
                          color: Colors.white,
                        );
                      } else {
                        return BlocConsumer<LocationBloc, LocationState>(
                          listenWhen: (previous, current) {
                            return ((previous.cityName != current.cityName) &&
                                !current.isLoading);
                          },
                          listener: (context, state) {
                            context
                                .read<WeatherBloc>()
                                .add(WeatherGetWeatherEvent());
                            context.read<WeatherBloc>().add(
                                  WeatherGet24hWeatherEvent(),
                                );
                            context.read<WeatherBloc>().add(
                                  WeatherGetWeekWeatherEvent(),
                                );
                          },
                          builder: (context, state) {
                            return Column(
                              children: [
                                Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Favorite location',
                                        textAlign: TextAlign.center,
                                        style: Fonts.msgTextStyle
                                            .copyWith(fontSize: 21),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () => showDialog(
                                          context: context,
                                          builder: ((context) {
                                            return SimpleDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(21),
                                              ),
                                              titlePadding:
                                                  const EdgeInsets.only(
                                                      top: 10),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 25,
                                                vertical: 10,
                                              ),
                                              title: const Text(
                                                'Favorite location',
                                                textAlign: TextAlign.center,
                                                style: Fonts.msgTextStyle,
                                              ),
                                              children: [
                                                Text(
                                                  'Favorite location would be used in home screen widget, notifications and always prioritet show when app is launched.',
                                                  textAlign: TextAlign.justify,
                                                  style: Fonts.msgTextStyle
                                                      .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12),
                                                  child: ElevatedButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: const Text(
                                                      'Ok',
                                                      style: Fonts.msgTextStyle,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                        radius: 16,
                                        borderRadius: BorderRadius.circular(12),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey.shade400,
                                          radius: 12,
                                          child: const Icon(
                                            Icons.question_mark_rounded,
                                            size: 16,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                                    (location) => ListTile(
                                      onTap: () {
                                        context.read<LocationBloc>().add(
                                              LocationSetCityEvent(
                                                  location.country ?? '',
                                                  location.city ?? ''),
                                            );
                                      },
                                      title: Text(
                                        location.city ?? '',
                                        textAlign: TextAlign.center,
                                        style: Fonts.headerTextStyle
                                            .copyWith(fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        location.country ?? '',
                                        textAlign: TextAlign.center,
                                        style: Fonts.msgTextStyle
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                const Divider(),
                                Column(
                                  children: [
                                    Text(
                                      'Another locations',
                                      textAlign: TextAlign.center,
                                      style: Fonts.msgTextStyle
                                          .copyWith(fontSize: 21),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EditLocationsScreen(),
                                        ),
                                      ),
                                      child: Text(
                                        'Edit locations',
                                        style: Fonts.msgTextStyle
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                if (locations.isEmpty)
                                  Text(
                                    'No locations',
                                    textAlign: TextAlign.center,
                                    style: Fonts.msgTextStyle.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                if (locations.isNotEmpty)
                                  ...locations.map(
                                    (location) => ListTile(
                                      onTap: () {
                                        context.read<LocationBloc>().add(
                                              LocationSetCityEvent(
                                                  location.country ?? '',
                                                  location.city ?? ''),
                                            );
                                      },
                                      title: Text(
                                        location.city ?? '',
                                        textAlign: TextAlign.center,
                                        style: Fonts.headerTextStyle
                                            .copyWith(fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        location.country ?? '',
                                        textAlign: TextAlign.center,
                                        style: Fonts.msgTextStyle
                                            .copyWith(fontSize: 14),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
