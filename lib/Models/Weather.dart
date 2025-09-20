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