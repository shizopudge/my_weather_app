import 'package:flutter/material.dart';
import 'package:my_weather_app/constants/font.dart';
import 'package:my_weather_app/models/city_model.dart';

class LocationWidget extends StatelessWidget {
  final CityModel city;
  const LocationWidget({
    super.key,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        city.cityName ?? '',
        style: Fonts.msgTextStyle,
      ),
      subtitle: Text(
        city.countryName ?? '',
        style: Fonts.msgTextStyle,
      ),
    );
  }
}
