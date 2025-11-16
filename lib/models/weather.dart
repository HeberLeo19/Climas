class Weather {
  final String city;
  final String countryCode; 
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.city,
    required this.countryCode,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'] ?? '',
      countryCode: (json['sys']?['country'] ?? '') as String,
      temperature: (json['main']['temp'] as num).toDouble(),
      description: (json['weather'][0]['description']) ?? '',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }
}
