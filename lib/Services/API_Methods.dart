// lib/Services/API_Methods.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/Weather.dart';

class WeatherService {
  static const String _apiKey = "ba389f38e48987b65685832e41ed4dd0";

  static Future<Weather> fetchWeather(String city) async {
    final response = await http.get(
      Uri.parse("http://api.weatherstack.com/current?access_key=$_apiKey&query=$city"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception("API Error!");
    }
  }
}
