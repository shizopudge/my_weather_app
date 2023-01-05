import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/home_screen.dart';
import 'package:my_weather_app/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocConsumer<LocalBloc, LocalState>(
        listener: (context, state) {
          if (state.isFirstLaunch && !state.isLoading) {
            Future.delayed(
              const Duration(seconds: 1),
              (() => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                  )),
            );
          } else if (!state.isFirstLaunch && !state.isLoading) {
            Future.delayed(
              const Duration(seconds: 1),
              (() => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  )),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Image.asset(
              'assets/icons/cloud.png',
              height: height * .35,
            ),
          );
        },
      ),
    );
  }
}
