import 'package:dio/dio.dart';
import 'package:weather_app_provider/model/weatherModel.dart';


class WeatherService {
  final String apiKey = 'f4deec0e95d482deb9e49e396c971636';  // Your API key
  final String apiUrl = 'https://api.openweathermap.org/data/2.5/weather';
  Dio dioInstance = Dio();

  // Fetch weather using city name
  Future<WeatherData> fetchWeather(String cityName) async {
    try {
      final response = await dioInstance.get(
        '$apiUrl',
        queryParameters: {
          'q': cityName,
          'appid': apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        // No need for jsonDecode, Dio already parses the response to JSON
        return WeatherData.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } on DioError catch (e) {
      print('Error fetching weather: $e');
      throw Exception('Failed to load weather data');
    }
  }

  // Fetch weather using coordinates
  Future<WeatherData> fetchWeatherByCoordinates(double lat, double lon) async {
    try {
      final response = await dioInstance.get(
        '$apiUrl',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        return WeatherData.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } on DioError catch (e) {
      print('Error fetching weather: $e');
      throw Exception('Failed to load weather data');
    }
  }
}
