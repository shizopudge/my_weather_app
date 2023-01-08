import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/bloc/locations/locations_bloc.dart';
import 'package:my_weather_app/bloc/settings/settings_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/constants/font.dart';
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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
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
                  BlocBuilder<LocationsBloc, LocationsState>(
                    builder: ((context, state) {
                      final locations = state.locations ?? [];
                      final favoriteLocations = state.favoriteLocations ?? [];
                      if (state.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Column(
                          children: [
                            Text(
                              'Favorite locations',
                              textAlign: TextAlign.center,
                              style: Fonts.msgTextStyle.copyWith(fontSize: 21),
                            ),
                            if (favoriteLocations.isEmpty)
                              Text(
                                'No favorite locations',
                                textAlign: TextAlign.center,
                                style: Fonts.msgTextStyle.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                            if (favoriteLocations.isNotEmpty)
                              ...favoriteLocations.map(
                                (location) => ListTile(
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
                            Text(
                              'Another locations',
                              textAlign: TextAlign.center,
                              style: Fonts.msgTextStyle.copyWith(fontSize: 21),
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
