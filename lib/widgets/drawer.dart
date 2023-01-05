import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/settings_screen.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            child: Stack(
              children: [
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
                BlocSelector<LocalBloc, LocalState, String>(
                  selector: (state) {
                    return state.theme;
                  },
                  builder: (context, state) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        radius: 100,
                        borderRadius: BorderRadius.circular(21),
                        onTap: () {
                          context.read<LocalBloc>().add(
                                LocalSetThemeStateEvent(
                                    state == 'light' ? 'dark' : 'light'),
                              );
                        },
                        child: state == 'light'
                            ? Icon(
                                Icons.sunny,
                                size: 32,
                                color: Colors.orange.shade500,
                              )
                            : const Icon(
                                Icons.nightlight,
                                size: 32,
                                color: Colors.black87,
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
