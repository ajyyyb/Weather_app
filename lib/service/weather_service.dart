import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';  // Для получения города по координатам
import '../models/weather_model.dart';

class WeatherService{
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService({required this.apiKey});

  // Метод для получения погоды
  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Метод для получения текущего города на основе геолокации
  Future<String> getCurrentCity() async {
    // Запросить разрешение на доступ к местоположению
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Получить текущие координаты
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Преобразовать координаты в список местоположений
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    // Извлечь название города
    String cityName = placemarks[0].locality ?? "Unknown city";  // Возвращаем "Unknown city", если название города не найдено

    return cityName;
  }
}
