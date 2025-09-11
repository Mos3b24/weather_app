import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();
  String city = "";
  late Future<Weather> weatherFuture;

  @override
  void initState() {
    super.initState();
    weatherFuture = fetchWeather(city);
  }

  Future<Weather> fetchWeather(String city) async {
    final response = await http.get(Uri.parse(
        'http://api.weatherstack.com/current?access_key=73e275f2d88e6aa0d4abb6072082dac2&query=$city'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception("API Error!");
    }
  }

  void _searchCity() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        city = _controller.text;
        weatherFuture = fetchWeather(city);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff184157),
        title: Text("Weather App",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: Colors.tealAccent,)
          )
      ),

      body: Column(
        children: [
          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter city name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchCity,
                  child: const Text("Search"),
                )
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder<Weather>(
                future: weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData) {
                    return const Text("No Data");
                  } else {
                    final weather = snapshot.data!;
                    return ListView(
                      children: [
                        Card(
                          elevation: 5,
                          margin: EdgeInsets.all(20),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${weather.city}, ${weather.country}",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Image.network(
                                  weather.icon,
                                  width: 100,
                                  height: 100,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "${weather.description}",
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Temperature: ${weather.temperature}°C",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Feels like: ${weather.feelsLike}°C",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Humidity: ${weather.humidity}%",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Wind: ${weather.windSpeed} km/h ${weather.windDir}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.favorite),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------- Weather Model -------------------------
class Weather {
  final String city;
  final String country;
  final int temperature;
  final int feelsLike;
  final int humidity;
  final int windSpeed;
  final String windDir;
  final String description;
  final String icon;

  Weather({
    required this.city,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDir,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json["location"]["name"],
      country: json["location"]["country"],
      temperature: json["current"]["temperature"],
      feelsLike: json["current"]["feelslike"],
      humidity: json["current"]["humidity"],
      windSpeed: json["current"]["wind_speed"],
      windDir: json["current"]["wind_dir"],
      description: json["current"]["weather_descriptions"][0],
      icon: json["current"]["weather_icons"][0],
    );
  }
}