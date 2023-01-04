import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/city/city_bloc.dart';
import 'package:my_weather_app/bloc/city/city_event.dart';
import 'package:my_weather_app/bloc/countries/country_bloc.dart';
import 'package:my_weather_app/bloc/countries/country_event.dart';
import 'package:my_weather_app/bloc/countries/country_state.dart';
import 'package:my_weather_app/change_city_screen.dart';
import 'package:my_weather_app/constants/font.dart';

class ChooseCountryScreen extends StatefulWidget {
  const ChooseCountryScreen({super.key});

  @override
  State<ChooseCountryScreen> createState() => _ChooseCountryScreenState();
}

class _ChooseCountryScreenState extends State<ChooseCountryScreen> {
  final TextEditingController _countryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final countryBloc = BlocProvider.of<CountryBloc>(context);
    final cityBloc = BlocProvider.of<CityBloc>(context);
    return Scaffold(
      body: BlocBuilder<CountryBloc, CountryState>(builder: (context, state) {
        final countries = state.countries;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Country',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: ((value) {
                      if (value.length >= 3) {
                        countryBloc.add(
                          CountrySearchCountryEvent(
                              value, countryBloc.state.countries),
                        );
                      } else if (value.isEmpty) {
                        countryBloc.add(CountryGetCountriesEvent());
                      } else {
                        return;
                      }
                    }),
                  ),
                ),
                if (state.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                if (!state.isLoading && state.countries.isEmpty)
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/cloud.png',
                        height: 120,
                      ),
                      const Text(
                        'Nothing found...',
                        textAlign: TextAlign.center,
                        style: Fonts.msgTextStyle,
                      )
                    ],
                  ),
                if (!state.isLoading && state.countries.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: countries.length,
                      itemBuilder: ((context, index) {
                        final country = countries[index];
                        return GestureDetector(
                          onTap: () {
                            cityBloc.add(
                              CityGetCititesEvent(
                                country.cities ?? [],
                                country.countryName ?? '',
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeCityScreen(
                                  finalCities: country.cities ?? [],
                                  country: country.countryName ?? '',
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.blue,
                            elevation: 16,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  country.countryName.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
