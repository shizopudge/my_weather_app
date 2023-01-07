class WeatherWeekModel {
  final String? iconDay;
  final String? iconNight;
  final String? avgTemp;
  final String? avgMinTemp;
  final String? avgMaxTemp;
  final String? avgHumidity;
  final String? weekday;
  final DateTime? dt;

  WeatherWeekModel({
    this.iconDay,
    this.iconNight,
    this.avgTemp,
    this.avgMinTemp,
    this.avgMaxTemp,
    this.avgHumidity,
    this.weekday,
    this.dt,
  });
}
