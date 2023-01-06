import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/bloc/settings/settings_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/constants/font.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final theme =
        context.select<LocalBloc, String>((value) => value.state.theme);
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                floating: true,
                snap: true,
                expandedHeight: height * .2,
                centerTitle: true,
                leading: InkWell(
                  radius: 100,
                  borderRadius: BorderRadius.circular(21),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
                flexibleSpace: Stack(
                  children: const [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Settings',
                        style: Fonts.headerTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: Card(
            color: Colors.grey.shade900,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Text(
                        'Units',
                        style: Fonts.headerTextStyle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ToggleButtons(
                          borderWidth: 1.5,
                          borderColor: Colors.white,
                          selectedBorderColor: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          fillColor: Colors.indigo,
                          onPressed: ((index) {
                            switch (index) {
                              case 0:
                                const String units = 'metric';
                                context.read<SettingsBloc>().add(
                                      SettingsChangeUnitsEvent(index, units),
                                    );
                                context.read<WeatherBloc>().add(
                                      WeatherGetWeatherEvent(),
                                    );
                                context.read<WeatherBloc>().add(
                                      WeatherGetSeveralWeatherEvent(),
                                    );
                                break;
                              case 1:
                                const String units = 'imperial';
                                context.read<SettingsBloc>().add(
                                      SettingsChangeUnitsEvent(index, units),
                                    );
                                context.read<WeatherBloc>().add(
                                      WeatherGetWeatherEvent(),
                                    );
                                context.read<WeatherBloc>().add(
                                      WeatherGetSeveralWeatherEvent(),
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
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/icons/fahrenheit.png',
                                height: 50,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1.5,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Theme',
                                style: Fonts.headerTextStyle.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              theme == 'light'
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
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Dark',
                                style: Fonts.msgTextStyle.copyWith(
                                  color: theme == 'dark'
                                      ? Colors.indigo
                                      : Colors.grey,
                                ),
                              ),
                              Switch.adaptive(
                                inactiveTrackColor: Colors.indigo,
                                activeTrackColor: Colors.indigo,
                                inactiveThumbColor: Colors.indigoAccent,
                                activeColor: Colors.indigoAccent,
                                value: theme == 'light',
                                onChanged: (value) {
                                  context.read<LocalBloc>().add(
                                        LocalSetThemeStateEvent(theme == 'light'
                                            ? 'dark'
                                            : 'light'),
                                      );
                                },
                              ),
                              Text(
                                'Light',
                                style: Fonts.msgTextStyle.copyWith(
                                  color: theme == 'light'
                                      ? Colors.indigo
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
