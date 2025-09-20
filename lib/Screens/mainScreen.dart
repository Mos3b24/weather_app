// lib/Screens/mainScreen.dart
import 'package:flutter/material.dart';
import '../Models/Weather.dart';
import '../Services/API_Methods.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();
  String city = "Irbid";
  late Future<Weather> weatherFuture;

  @override
  void initState() {
    super.initState();
    weatherFuture = WeatherService.fetchWeather(city);
  }

  void _searchCity() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        city = _controller.text;
        weatherFuture = WeatherService.fetchWeather(city);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff184157),
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.tealAccent,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
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
                          margin: const EdgeInsets.all(20),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${weather.city}, ${weather.country}",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Image.network(
                                  weather.icon,
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  weather.description,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Temperature: ${weather.temperature}°C",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Feels like: ${weather.feelsLike}°C",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Humidity: ${weather.humidity}%",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Wind: ${weather.windSpeed} km/h ${weather.windDir}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.favorite),
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
