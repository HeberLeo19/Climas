import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/weather.dart';

class WeatherService {
  static const String _apiKey = '2d3bd7e6f434838f38a73115e3bdeaea';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> getWeatherByCity(String city, String countryCode) async {
    final uri = Uri.parse(
      '$_baseUrl/weather?q=$city,$countryCode&appid=$_apiKey&units=metric&lang=es',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception(
        'Error al obtener el clima (${response.statusCode}): ${response.body}',
      );
    }
  }
}
