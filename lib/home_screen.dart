import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_state.dart';
import 'package:my_weather_app/choose_country_screen.dart';
import 'package:my_weather_app/constants/font.dart';
import 'package:my_weather_app/widgets/bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<WeatherBloc, WeatherState>(
              builder: ((context, state) {
                final weather = state.weather;
                if (state.isError) {
                  return const Center(
                    child: Text('Something went wrong...'),
                  );
                }
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!state.isError && !state.isLoading) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) =>
                                  const ChooseCountryScreen()),
                            ),
                          );
                        },
                        child: Text(
                          state.city,
                          style: Fonts.headerTextStyle,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                                elevation: 16,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                context: context,
                                builder: ((context) {
                                  return UnitsChooseBottomSheet(
                                    unitsType: state.units,
                                  );
                                }));
                          },
                          child: Text(state.units)),
                      Text(
                        weather.temp.toString(),
                      ),
                      Text(
                        weather.weatherMain ?? 'none',
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
