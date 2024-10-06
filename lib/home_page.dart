import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_provider/Provider/weatherProvider.dart';



class CurrentLocationWeather extends StatelessWidget {
  const CurrentLocationWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return CurrentLocation();
  }
}

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  @override
  void initState() {
    super.initState();
    // Use Future.delayed to ensure the fetch occurs after the widget is built
    Future.delayed(Duration.zero, () {
      // Fetch weather based on the current location at the start
      Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeatherByLocation();
    });
  }

  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Access the WeatherProvider
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show loading indicator while weather data is being fetched
              if (weatherProvider.loading)
                Center(child: CircularProgressIndicator()),

              // If weather data is available, display it
              if (!weatherProvider.loading && weatherProvider.weather != null)
                Container(
                  height: 700.0,
                  child: Stack(
                    children: [
                      /// Background
                      Align(
                        alignment: AlignmentDirectional(3, -1),
                        child: Container(
                          height: 300,
                          width: 400,
                          decoration: BoxDecoration(
                            color: Colors.cyanAccent,
                            //shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(1, -0.50),
                        child: Container(
                          height: 400,
                          width: 400,
                          decoration: BoxDecoration(
                            color: Colors.indigoAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(3, 1.5),
                        child: Container(
                          height: 400,
                          width: 400,
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),

                      /// frontPage Layout
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///CityNmae and Search Icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Text(
                                    '📍${weatherProvider.weather!.name}, ${weatherProvider.weather!.sys.country}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          // Create a local reference to the weatherProvider
                                          final weatherProvider =
                                              Provider.of<WeatherProvider>(
                                                  context,
                                                  listen: false);

                                          return StatefulBuilder(
                                            builder: (BuildContext context,
                                                StateSetter setState) {
                                              return AlertDialog(
                                                title:
                                                    Text('Enter any City Name'),
                                                content: Container(
                                                  height: 150.0,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            _cityController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Enter city name',
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          final cityName =
                                                              _cityController
                                                                  .text;

                                                          if (cityName
                                                              .isNotEmpty) {
                                                            // Set loading to true while fetching weather data
                                                            setState(() {});
                                                            await weatherProvider
                                                                .fetchWeather(
                                                                    cityName);

                                                            // If needed, close the dialog only after fetching weather
                                                            if (!weatherProvider
                                                                .loading) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close dialog
                                                            }
                                                          }
                                                        },
                                                        child:
                                                            Text('Get Weather'),
                                                      ),
                                                      // SizedBox(height: 20),
                                                      // if (weatherProvider.loading)
                                                      //   CircularProgressIndicator(),
                                                      // if (!weatherProvider.loading && weatherProvider.weather != null)
                                                      //   WeatherDisplay(weather: weatherProvider.weather!),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.search_rounded,
                                      size: 30.0,
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            /// Greeting Msg
                            Container(
                              margin: EdgeInsets.only(left: 8.0),
                              child: Text(
                                getGreetingMessage(),
                                // 'Good Morning',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),

                            /// image according to Weather_description/condition
                            Container(
                              height: 280.0,
                              child: Center(
                                child: GetWeatherIcon(weatherProvider
                                    .weather!.weather[0].description),
                                //  Image.asset('assets/5.png'),
                              ),
                            ),

                            /// Temprature
                            Center(
                              child: Text(
                                '${weatherProvider.weather!.main.temp.round()}°C',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),

                            ///Weather Condition
                            Center(
                              child: Text(
                                '${weatherProvider.weather!.weather[0].description}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(height: 5),

                            ///Current Date and Time
                            Center(
                              child: Text(
                                //'date and time',
                                DateFormat('EEEE dd -')
                                    .add_jm()
                                    .format(DateTime.now()),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            const SizedBox(height: 40),

                            ///SunRise & sunset Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/11.png',
                                      scale: 8,
                                    ),
                                    // const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Sunrise',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          //'sunrise time',
                                          '${DateFormat.jm().format(weatherProvider.weather!.sys.sunrise)}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/12.png',
                                      scale: 8,
                                    ),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Sunset',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          //'sunset time',
                                          '${DateFormat.jm().format(weatherProvider.weather!.sys.sunset)}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Center(
                              child: Container(
                                width: 320.0,
                                child: Divider(
                                    // color: Colors.grey,
                                    ),
                              ),
                            ),

                            ///TempMax & TempMin Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(children: [
                                  Image.asset(
                                    'assets/13.png',
                                    scale: 8,
                                  ),
                                  // const SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Temp Max',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${weatherProvider.weather!.main.tempMax.round()} °C',
                                        //'${state.weather.tempMax!.celsius!.round()} °C',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  )
                                ]),
                                Row(children: [
                                  Image.asset(
                                    'assets/14.png',
                                    scale: 8,
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Temp Min',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${weatherProvider.weather!.main.tempMin.round()} °C',
                                        //'${state.weather.tempMin!.celsius!.round()} °C',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  )
                                ])
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              // If no weather data is available and not loading, show an error or empty state
              if (!weatherProvider.loading && weatherProvider.weather == null)
                Center(
                  child: Text(
                    'Unable to fetch weather data',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String getGreetingMessage() {
    final DateTime now = DateTime.now();
    final String formattedTime =
        DateFormat('Hm').format(now); // Get current time in 24-hour format

    final hour = int.parse(formattedTime.split(":")[0]);

    if (hour >= 0 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  Widget GetWeatherIcon(String description) {
    switch (description) {
      case 'clear sky':
        return Image.asset('assets/6.png');

      case 'few clouds':
        return Image.asset('assets/7.png');
      // print('There are a few clouds in the sky.');

      case 'scattered clouds':
        return Image.asset('assets/9.png');
      // print('Scattered clouds in the sky.');

      case 'broken clouds':
        return Image.asset('assets/5.png');
      //  print('The clouds are broken up, partial sunshine.');

      case 'shower rain':
        return Image.asset('assets/3.png');
      // print('There is shower rain, take an umbrella.');

      case 'rain':
        return Image.asset('assets/2.png');

      case 'light rain':
        return Image.asset('assets/2.png');
      // print('It\'s raining, stay dry!');

      case 'thunderstorm':
        return Image.asset('assets/1.png');
      // print('Thunderstorm! Stay indoors for safety.');

      case 'snow':
        return Image.asset('assets/5.png');
      // print('Snowfall outside! Bundle up.');

      case 'mist':
        return Image.asset('assets/4.png');

      case 'smoke':
        return Image.asset('assets/5.png');
      //   print('Misty weather, drive carefully.');
      default:
        return Image.asset('assets/8.png');
      //print('Weather condition not recognized.');
    }
  }
}
