import 'package:flutter/material.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: favoriteCity(),
    );
  }
}


class favoriteCity extends StatefulWidget {
  const favoriteCity({super.key});

  @override
  State<favoriteCity> createState() => _favoriteCityState();
}

class _favoriteCityState extends State<favoriteCity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}