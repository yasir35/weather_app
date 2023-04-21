import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final cityController = TextEditingController();
  String city = '';
  String temp = '';
  String description = '';
  String icon = '';
  List<dynamic> hourlyForecast = [];
  String airPollution = '';
  bool isLoading = false;

  Future getWeatherData(String city) async {
    const apiKey = '0b56760c8438b160acb11e4674b19743';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      setState(() {
        temp = data['main']['temp'].toString();
        description = data['weather'][0]['description'];
        icon = data['weather'][0]['icon'];
        isLoading = false;
      });
      final lat = data['coord']['lat'];
      final lon = data['coord']['lon'];

      // Get air pollution data
      final pollutionUrl =
          'https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey';
      final pollutionResponse = await http.get(Uri.parse(pollutionUrl));
      final pollutionData = jsonDecode(pollutionResponse.body);
      final currentAQI = pollutionData['list'][0]['main']['aqi'];

      // Update UI with air pollution data
      setState(() {
        airPollution = currentAQI.toString();
      });
      await getHourlyForecast(
          data['coord']['lat'], data['coord']['lon'], apiKey);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to get weather data. Please try again.'),
        ),
      );
    }
  }

  Future getHourlyForecast(double lat, double lon, String apiKey) async {
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      setState(() {
        hourlyForecast = data['list'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Failed to get hourly forecast data. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 19, 74, 150),
          Color.fromARGB(255, 37, 88, 183),
          Color.fromARGB(255, 41, 87, 179)
        ],
      )),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Mausami',
            style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lobster-Regular'),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'Enter a city',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onChanged: (value) {
                  city = value;
                },
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  getWeatherData(city);
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,
                  elevation: 4,
                ),
                child: const Text('Get Weather'),
              ),
              const SizedBox(height: 16),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    backgroundColor: Colors.blue[500],
                  ),
                ),
              if (temp.isNotEmpty && !isLoading)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://openweathermap.org/img/wn/$icon.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$temp°C',
                        style: const TextStyle(fontSize: 40),
                      ),
                      Text(description,
                          style: const TextStyle(
                            color: Colors.white,
                          )),
                      const SizedBox(height: 16),
                      const Text(
                        '3-hour Forecast for the next 5 days:',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Pacifico-Regular',
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                            itemCount: hourlyForecast.length,
                            itemBuilder: (context, index) {
                              final forecast = hourlyForecast[index];
                              final dt = DateTime.fromMillisecondsSinceEpoch(
                                  forecast['dt'] * 1000);
                              final hour = dt.hour.toString().padLeft(2, '0');
                              final temp = forecast['main']['temp'] != null
                                  ? forecast['main']['temp'].toStringAsFixed(0)
                                  : '';
                              final icon = forecast['weather'][0]['icon'];
                              return ListTile(
                                leading: Image.network(
                                  'https://openweathermap.org/img/wn/$icon.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.contain,
                                ),
                                title: Text('$temp°C'),
                                subtitle: Text('$hour:00'),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Air Pollution: $airPollution',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Pacifico-Regular',
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
