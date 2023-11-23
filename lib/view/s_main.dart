import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/constants/gaps.dart';
import 'package:flutter_weather_app/constants/palette.dart';
import 'package:flutter_weather_app/constants/paths.dart';
import 'package:flutter_weather_app/model/weather.dart';
import 'package:flutter_weather_app/service/api_service.dart';
import 'package:flutter_weather_app/view/w_weather_lottie.dart';
import 'package:lottie/lottie.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<Weather> currentWeather;

  @override
  void initState() {
    currentWeather = ApiService.getCurrentWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      body: FutureBuilder(
        future: currentWeather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child:
                  Lottie.asset("./assets/animations/loading.json", height: 80),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  gap100h,
                  Lottie.asset("./assets/animations/error.json", height: 200),
                  Text(
                    "Failed to load weather data",
                    style: TextStyle(color: Palette.text),
                  )
                ],
              ),
            );
          } else {
            Weather weather = snapshot.data!;
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    gap50h,
                    Text(
                      "Seoul",
                      style: TextStyle(
                        color: Palette.text,
                        fontSize: 30,
                      ),
                    ),
                    createWeatherAnimation(weather.main),
                    Text(
                      "${weather.desc} / ${weather.temp} ℃",
                      style: TextStyle(
                        color: Palette.text,
                        fontSize: 20,
                      ),
                    ),
                    gap20h,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentWeather = ApiService.getCurrentWeather();
                        });
                      },
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Palette.point,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Refresh',
                              style: TextStyle(
                                color: Palette.text,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget createWeatherAnimation(String param) {
    var url = "";
    switch (param) {
      case "Clear":
        url = Paths.clear;
        break;
      case "Clouds":
        url = Paths.clouds;
        break;
      case "Rain":
        url = Paths.rain;
        break;
      case "Snow":
        url = Paths.snow;
        break;
      case "Thunderstorm":
        url = Paths.storm;
        break;
      case "Drizzle":
        url = Paths.drizzle;
        break;
      case "Atmosphere":
      default:
        url = Paths.atmosphere;
    }
    return WeatherLottieWidget(url: url);
  }
}
