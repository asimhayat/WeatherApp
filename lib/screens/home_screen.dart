import 'package:firstpro/consts.dart';
import 'package:firstpro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherFactory wf = WeatherFactory(OPENWEATHER_API_KEY);

  late String selectedLocation = "Karachi";

  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData(selectedLocation);
  }

  void _fetchWeatherData(String location) {
    wf.currentWeatherByCityName(location).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2B3163),
              Color(0xFF433A8C),
              Color(0xFF8550AC),
            ],
          ),
        ),
        child: ui(),
      ),
    );
  }

  Widget ui() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          locationHeader(),
          Image.asset(
            "images/cloud.png",
            height: 300,
          ),
          currentTemp(),
          timedate(),
          SizedBox(height: 20),
          squareWithMinMax(),
        ],
      ),
    );
  }

  Widget locationHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<String>(
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppColors.primary,
          ),
          value: selectedLocation,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedLocation = newValue;
              });
              _fetchWeatherData(selectedLocation);
            }
          },
          items: <String>['Karachi', 'Lahore', 'Hyderabad', 'Islamabad']
              .map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style: TextStyle(fontSize: 20, color: AppColors.primary)),
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  Widget timedate() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(fontSize: 35, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            Text(
              "  ${DateFormat("d-M-y").format(now)}",
              style: const TextStyle(
                  fontWeight: FontWeight.w400, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
      style: const TextStyle(
          color: Colors.white, fontSize: 55, fontWeight: FontWeight.w500),
    );
  }

  Widget squareWithMinMax() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: const Color(0xFF8550AC),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }
}
