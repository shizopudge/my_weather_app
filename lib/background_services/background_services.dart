import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/models/location_model.dart';
import 'package:my_weather_app/models/weather_model.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class BackgroundServices {
  static final _httpClient = Dio(
    BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 10000,
    ),
  );

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    Timer.periodic(const Duration(hours: 6), (timer) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final isFirstLaunch = prefs.getBool('isFirstLaunch');
      if (isFirstLaunch ?? true) {
        return;
      } else {
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        AndroidInitializationSettings androidInitialize =
            const AndroidInitializationSettings('@drawable/ic_launcher');
        DarwinInitializationSettings iosInitialize =
            const DarwinInitializationSettings();
        InitializationSettings initializationsSetting = InitializationSettings(
            android: androidInitialize, iOS: iosInitialize);
        await flutterLocalNotificationsPlugin
            .initialize(initializationsSetting);
        AndroidNotificationDetails androidPlatformChannelSpecifics =
            const AndroidNotificationDetails(
          'AndroidNoti',
          'Weather Forecast',
          importance: Importance.max,
          priority: Priority.max,
        );
        final platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: const DarwinNotificationDetails(),
        );
        final db = await openDatabase(
          join(await getDatabasesPath(), 'locations.db'),
        );
        final List<Map<String, dynamic>> favoriteLocationsMaps =
            await db.query('favorite_locations');
        List<LocationModel> favoriteLocations =
            List.generate(favoriteLocationsMaps.length, (i) {
          return LocationModel(
            id: favoriteLocationsMaps[i]['id'],
            city: favoriteLocationsMaps[i]['city'],
            country: favoriteLocationsMaps[i]['country'],
          );
        });
        if (favoriteLocations.isNotEmpty) {
          final String? units = prefs.getString('units');
          final Response res = await _httpClient.get(
              'https://api.openweathermap.org/data/2.5/weather',
              queryParameters: {
                'q': favoriteLocations.first.city,
                'units': units,
                'appid': '476834e607173de250e2b4595cc852af',
              });
          if (res.statusCode == 200) {
            final WeatherModel weather = WeatherModel.fromJson(res.data);
            await flutterLocalNotificationsPlugin.show(
              1,
              '${weather.temp}° ${weather.cityName}',
              '${weather.weatherMain}/${weather.weatherDescription}\n${weather.tempMax}°/${weather.tempMin}°',
              platformChannelSpecifics,
            );
            await HomeWidget.saveWidgetData<String>(
                '_temp', WeatherModel.fromJson(res.data).temp ?? '');
            await HomeWidget.saveWidgetData<String>('_description',
                '${WeatherModel.fromJson(res.data).weatherMain}/${WeatherModel.fromJson(res.data).weatherDescription}');
            await HomeWidget.saveWidgetData<String>(
                '_city', favoriteLocations.first.city ?? '');
            await HomeWidget.saveWidgetData<String>(
              '_updated',
              DateFormat('dd.MM HH:mm').format(
                DateTime.now(),
              ),
            );
            await HomeWidget.updateWidget(
                name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
          } else {
            throw Exception('Something went wrong');
          }
        }
      }
    });
  }

  static Future initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        autoStartOnBoot: true,
        isForegroundMode: true,
        initialNotificationContent: 'Background services running',
        initialNotificationTitle: 'Weather Forecast',
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future backgroundCallback(uri) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'locations.db'),
    );
    final List<Map<String, dynamic>> favoriteLocationsMaps =
        await db.query('favorite_locations');
    List<LocationModel> favoriteLocations =
        List.generate(favoriteLocationsMaps.length, (i) {
      return LocationModel(
        id: favoriteLocationsMaps[i]['id'],
        city: favoriteLocationsMaps[i]['city'],
        country: favoriteLocationsMaps[i]['country'],
      );
    });
    if (favoriteLocations.isNotEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? units = prefs.getString('units');
      final Response res = await _httpClient.get(
          'https://api.openweathermap.org/data/2.5/weather',
          queryParameters: {
            'q': favoriteLocations.first.city,
            'units': units,
            'appid': '476834e607173de250e2b4595cc852af',
          });
      if (res.statusCode == 200) {
        await HomeWidget.saveWidgetData<String>(
            '_temp', WeatherModel.fromJson(res.data).temp ?? '');
        await HomeWidget.saveWidgetData<String>('_description',
            '${WeatherModel.fromJson(res.data).weatherMain}/${WeatherModel.fromJson(res.data).weatherDescription}');
        await HomeWidget.saveWidgetData<String>(
            '_city', favoriteLocations.first.city ?? '');
        await HomeWidget.saveWidgetData<String>(
          '_updated',
          DateFormat('dd.MM HH:mm').format(
            DateTime.now(),
          ),
        );
        await HomeWidget.updateWidget(
            name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
      } else {
        throw Exception('Something went wrong');
      }
    } else {
      await HomeWidget.saveWidgetData<String>('_temp', '');
      await HomeWidget.saveWidgetData<String>('_description', '');
      await HomeWidget.saveWidgetData<String>('_city', '');
      await HomeWidget.saveWidgetData<String>('_updated', '');
      await HomeWidget.updateWidget(
          name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
    }
  }
}
