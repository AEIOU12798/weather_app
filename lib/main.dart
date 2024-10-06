
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_provider/Provider/weatherProvider.dart';
import 'home_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          home: CurrentLocationWeather()),
    ),
  );
}



