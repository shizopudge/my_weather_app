import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_state.dart';
import 'package:my_weather_app/constants/images.dart';
import 'package:my_weather_app/models/weather_model.dart';
import 'package:my_weather_app/widgets/additional_info_widget.dart';

class WeatherAdditionWidget extends StatelessWidget {
  final WeatherModel weather;
  const WeatherAdditionWidget({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(21),
      ),
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            AdditionInfoListTile(
              trailing: DateFormat('HH:mm').format(
                DateTime.fromMillisecondsSinceEpoch(
                    (weather.sunrise ?? 0) * 1000),
              ),
              title: 'Sunrise',
              leading: ConstImages.sunrise,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(),
            ),
            AdditionInfoListTile(
              trailing: DateFormat('HH:mm').format(
                DateTime.fromMillisecondsSinceEpoch(
                    (weather.sunset ?? 0) * 1000),
              ),
              title: 'Sunset',
              leading: ConstImages.sunset,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(),
            ),
            AdditionInfoListTile(
              trailing: '${weather.humidity}%',
              title: 'Humidity',
              leading: ConstImages.humidity,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(),
            ),
            BlocSelector<WeatherBloc, WeatherState, String>(
              selector: (state) {
                return state.units;
              },
              builder: (context, state) {
                if (state == 'metric') {
                  return AdditionInfoListTile(
                    trailing: '${weather.windSpeed} meter/sec',
                    title: 'Wind',
                    leading: ConstImages.wind,
                  );
                } else {
                  return AdditionInfoListTile(
                    trailing: '${weather.windSpeed} miles/hour',
                    title: 'Wind',
                    leading: ConstImages.wind,
                  );
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(),
            ),
            AdditionInfoListTile(
              trailing: '${weather.clouds}%',
              title: 'Cloudiness',
              leading: ConstImages.cloudiness,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(),
            ),
            AdditionInfoListTile(
              trailing: '${weather.pressure} hPa',
              title: 'Pressure',
              leading: ConstImages.pressure,
            ),
          ],
        ),
      ),
    );
  }
}
