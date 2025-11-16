import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService _weatherService = WeatherService();

  final TextEditingController _cityController =
      TextEditingController(text: 'Guatemala City');

  
  final Map<String, String> _countries = {
    'GT': 'Guatemala',
    'MX': 'México',
    'US': 'Estados Unidos',
    'AR': 'Argentina',
    'CO': 'Colombia',
    'PE': 'Perú',
    'ES': 'España',
    'BR': 'Brasil',
  };

  
  final Map<String, String> _defaultCities = {
    'GT': 'Guatemala City',
    'MX': 'Ciudad de México',
    'US': 'New York',
    'AR': 'Buenos Aires',
    'CO': 'Bogotá',
    'PE': 'Lima',
    'ES': 'Madrid',
    'BR': 'São Paulo',
  };

  String _selectedCountryCode = 'GT';

  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  
  String _countryFlag(String code) {
    final countryCode = code.toUpperCase();
    if (countryCode.length != 2) return '';
    final int first = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int second = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCodes([first, second]);
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _weatherService.getWeatherByCity(
        _cityController.text.trim(),
        _selectedCountryCode,
      );
      setState(() {
        _weather = result;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _weather = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    
    _cityController.text = _defaultCities[_selectedCountryCode] ??
        _cityController.text;

    
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronóstico del tiempo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Ciudad',
                border: OutlineInputBorder(),
                hintText: 'Ingresa una ciudad (ej: Guatemala City)',
              ),
            ),
            const SizedBox(height: 12),

            
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'País',
                border: OutlineInputBorder(),
              ),
              value: _selectedCountryCode,
              items: _countries.entries.map((entry) {
                final code = entry.key;
                final name = entry.value;
                final flag = _countryFlag(code);
                return DropdownMenuItem(
                  value: code,
                  child: Text('$flag $name ($code)'),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedCountryCode = value;
                  
                  _cityController.text = _defaultCities[value] ?? '';
                });
              },
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _fetchWeather,
                icon: const Icon(Icons.cloud),
                label: const Text('Consultar clima'),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            if (_weather != null) _buildWeatherCard(_weather!),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(Weather weather) {
    final flag = _countryFlag(weather.countryCode);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              weather.city,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            if (weather.countryCode.isNotEmpty)
              Text(
                '$flag  ${weather.countryCode}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

            const SizedBox(height: 8),
            Text(
              '${weather.temperature.toStringAsFixed(1)} °C',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              weather.description.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.water_drop_outlined),
                const SizedBox(width: 4),
                Text('Humedad: ${weather.humidity}%'),
                const SizedBox(width: 16),
                const Icon(Icons.air),
                const SizedBox(width: 4),
                Text('Viento: ${weather.windSpeed} m/s'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
