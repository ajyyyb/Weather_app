import 'package:flutter_test/flutter_test.dart';

import 'package:pagoda/models/weather_model.dart';

void main() {
  test('Weather.fromJson reads the city, temperature and condition', () {
    final weather = Weather.fromJson({
      'name': 'Bishkek',
      'main': {'temp': 12},
      'weather': [
        {'main': 'Clouds'},
      ],
    });

    expect(weather.cityName, 'Bishkek');
    expect(weather.temperature, 12.0);
    expect(weather.mainCondition, 'Clouds');
  });

  test('a whole-number temperature from the API becomes a double', () {
    final weather = Weather.fromJson({
      'name': 'Osh',
      'main': {'temp': 20},
      'weather': [
        {'main': 'Clear'},
      ],
    });

    expect(weather.temperature, isA<double>());
  });
}
