import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_state.dart';
import 'package:my_weather_app/constants/font.dart';
import 'package:my_weather_app/models/weather_model.dart';

class WeatherMainWidget extends StatelessWidget {
  final WeatherModel weather;
  const WeatherMainWidget({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(21),
      ),
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          isAntiAlias: true,
                          filterQuality: FilterQuality.high,
                          image: NetworkImage(
                            'http://openweathermap.org/img/wn/${weather.icon}.png',
                          ),
                        ),
                      ),
                    ),
                    Text(
                      weather.weatherMain ?? '',
                      style: Fonts.msgTextStyle.copyWith(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.temp.toString(),
                      style: Fonts.headerTextStyle,
                    ),
                    BlocSelector<WeatherBloc, WeatherState, String>(
                      selector: (state) {
                        return state.units;
                      },
                      builder: (context, state) {
                        if (state == 'metric') {
                          return Image.asset(
                            'assets/icons/celsius.png',
                            height: 18,
                            color: Colors.white,
                          );
                        } else {
                          return Image.asset(
                            'assets/icons/fahrenheit.png',
                            height: 18,
                            color: Colors.white,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
