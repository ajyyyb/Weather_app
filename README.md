# Weather_app

A Flutter app that shows the current weather for a city, with an animation for the weather and a hint on what to wear. The interface text is in Kyrgyz.

## Features

- Search a city by name; Osh is shown on start.
- Temperature and weather condition from the OpenWeatherMap current weather API (metric units).
- A Lottie animation for the condition: sunny, cloudy, rain or thunder.
- A clothing recommendation based on the temperature and the condition.
- `WeatherService.getCurrentCity()` can detect the current city from the phone location (`geolocator` + `geocoding`).
- A message is shown when the city is not found.

## Stack

Flutter, `http`, `lottie`, `geolocator`, `geocoding`.

## Project structure

```text
lib/
  main.dart
  models/weather_model.dart     weather data parsed from the API answer
  service/weather_service.dart  API request and current city by location
  pages/weather_page.dart       the screen
assets/                         Lottie animations (sunny, cloud, rain, thunder)
```

## Run it

1. Get a free API key at [openweathermap.org](https://openweathermap.org/api).
2. Put it into `WeatherService(apiKey: ...)` in `lib/pages/weather_page.dart`. Do not commit a real key to a public repository.
3. Run:

```bash
flutter pub get
flutter run
```
