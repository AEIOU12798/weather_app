import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_provider/model/weatherModel.dart';
import '../api_caller.dart';


class WeatherProvider with ChangeNotifier {
  WeatherData? _weather;
  bool _loading = false;

  WeatherData? get weather => _weather;
  bool get loading => _loading;

  final WeatherService _weatherService = WeatherService();

  // Fetch weather based on city name
  Future<void> fetchWeather(String cityName) async {
    _loading = true;
    notifyListeners();

    try {
      _weather = await _weatherService.fetchWeather(cityName);
    } catch (e) {
      print('Error fetching weather: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Fetch weather using device's location
  Future<void> fetchWeatherByLocation() async {
    _loading = true;
    notifyListeners();

    try {
      Position position = await _determinePosition();
      _weather = await _weatherService.fetchWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      print('Error fetching weather by location: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Determine the current position of the device
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
     // return Future.error('Location services are disabled.');
    }
    notifyListeners();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    return await Geolocator.getCurrentPosition();
  }

}
