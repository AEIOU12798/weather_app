class WeatherData {
  Coord coord;
  List<Weather> weather;
  Main main;
  Wind wind;
  Clouds clouds;
  Sys sys;
  int dt;
  String name;
  int timezone;

  WeatherData({
    required this.coord,
    required this.weather,
    required this.main,
    required this.wind,
    required this.clouds,
    required this.sys,
    required this.dt,
    required this.name,
    required this.timezone,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      coord: Coord.fromJson(json['coord']),
      weather: List<Weather>.from(json['weather'].map((x) => Weather.fromJson(x))),
      main: Main.fromJson(json['main']),
      wind: Wind.fromJson(json['wind']),
      clouds: Clouds.fromJson(json['clouds']),
      sys: Sys.fromJson(json['sys']),
      dt: json['dt'],
      name: json['name'],
      timezone: json['timezone'],
    );
  }
}

class Coord {
  double lon;
  double lat;

  Coord({required this.lon, required this.lat});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lon: json['lon'],
      lat: json['lat'],
    );
  }
}

class Weather {
  int id;
  String main;
  String description;
  String icon;

  Weather({required this.id, required this.main, required this.description, required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}

class Main {
  double temp;
  double feelsLike;
  double tempMin;
  double tempMax;
  int pressure;
  int humidity;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'],
      feelsLike: json['feels_like'],
      tempMin: json['temp_min'],
      tempMax: json['temp_max'],
      pressure: json['pressure'],
      humidity: json['humidity'],
    );
  }
}

class Wind {
  double speed;
  int deg;

  Wind({required this.speed, required this.deg});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed'],
      deg: json['deg'],
    );
  }
}

class Clouds {
  int all;

  Clouds({required this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(
      all: json['all'],
    );
  }
}

class Sys {
  String country;
  DateTime sunrise;
  DateTime sunset;

  Sys({required this.country, required this.sunrise, required this.sunset});

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      country: json['country'],
      sunrise: DateTime.fromMillisecondsSinceEpoch(json['sunrise'] * 1000),  // Convert Unix timestamp to DateTime
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sunset'] * 1000),
    );
  }
}
