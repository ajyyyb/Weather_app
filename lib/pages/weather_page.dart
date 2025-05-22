import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pagoda/models/weather_model.dart';
import 'package:pagoda/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService(apiKey: '1d609cc51843054a1a45a40ebc3ed7a3');
  final _cityController = TextEditingController();
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData("Osh"); // Начальный город
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  // Погода маалыматтарын алуу
  _fetchWeatherData(String cityName) async {
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Шаар табылган жок')),
      );
    }
  }

  // Аба ырайы боюнча кийим сунушу
  String getClothingRecommendation(double temperature, String mainCondition) {
    if (mainCondition == "Clear" || mainCondition == "Clouds") {
      if (temperature > 25) {
        return "Бүгүн жылуу аба ырайы, жеңил кийим кийиңиз.";
      } else if (temperature > 15) {
        return "Жакшы аба ырайы, жеңил, бирок узун жылуу кийим кийиңиз.";
      } else {
        return "Суук, жакшылап куртка кийип алыңыз.";
      }
    } else if (mainCondition == "Rain" || mainCondition == "Drizzle" || mainCondition == "Thunderstorm") {
      return "Жамгыр жаап жатат, чамбар ала кетүүнү унутпаңыз!";
    } else if (mainCondition == "Snow") {
      return "Кар жаап жатат, жылуу кийим жана бут кийим кийиңиз.";
    } else {
      return "Абаны аныктоо кыйын, кийимдериңизди аба ырайына жараша тандаңыз!";
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Поиск шаары
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cityController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Шаарды жазыңыз...',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_cityController.text.isNotEmpty) {
                        _fetchWeatherData(_cityController.text);
                      }
                    },
                    child: Text('Издөө'),
                  ),
                ],
              ),
              
              SizedBox(height: 20),

              // Аба ырайынын маалыматтары
              Expanded(
                child: _weather == null
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _weather?.cityName ?? "Жүктөлүүдө...",
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                          
                          Lottie.asset(
                            getWeatherAnimation(_weather?.mainCondition),
                            height: 200,
                          ),

                          Text(
                            '${_weather?.temperature.round()}°C',
                            style: TextStyle(fontSize: 32, color: Colors.white),
                          ),

                          Text(
                            _weather?.mainCondition ?? "",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              getClothingRecommendation(
                                _weather?.temperature ?? 0.0,
                                _weather?.mainCondition ?? "",
                              ),
                              style: TextStyle(fontSize: 20, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}