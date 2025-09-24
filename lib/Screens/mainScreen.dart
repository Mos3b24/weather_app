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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          title: const Text(
            'Weather App',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(blurRadius: 6, color: Colors.black38, offset: Offset(1, 2)),
              ],
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3366FF), Color(0xFF00CCFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Enter city name",
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.location_city, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _searchCity,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: const Color(0xFF3366FF),
                      ),
                      child: const Text(
                        "Search",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: FutureBuilder<Weather>(
                future: weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } 
                  else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } 
                  else if (!snapshot.hasData) {
                    return const Text("No Data");
                  } 
                  else {
                    final weather = snapshot.data!;
                    return ListView(
                      children: [
                        Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.all(20),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${weather.city}, ${weather.country}",
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF184157),
                                  ),
                                ),
                                const SizedBox(height: 15),

                                Text(
                                  weather.description,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 15),

                                Text(
                                  "${weather.temperature}°C",
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                Wrap(
                                  spacing: 20,
                                  runSpacing: 10,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    _infoTile(Icons.thermostat, "Feels like: ${weather.feelsLike}°C"),
                                    _infoTile(Icons.water_drop, "Humidity: ${weather.humidity}%"),
                                    _infoTile(Icons.air, "Wind: ${weather.windSpeed} km/h ${weather.windDir}"),
                                  ],
                                ),

                                const SizedBox(height: 15),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.favorite, color: Colors.redAccent, size: 28),
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

  Widget _infoTile(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
