import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/main-bg.jpg',
              ),
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
            ),
          ),
          child: BlocBuilder<LocalBloc, LocalState>(
            builder: (context, state) {
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      floating: true,
                      snap: true,
                      expandedHeight: height * .2,
                      centerTitle: true,
                      leadingWidth: 35,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                  color: Colors.black,
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: BlocBuilder<SettingsBloc, SettingsState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Units',
                                    style: Fonts.headerTextStyle,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: ToggleButtons(
                                      borderWidth: 1.5,
                                      borderRadius: BorderRadius.circular(12),
                                      fillColor: Colors.lightGreen.shade400,
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
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
