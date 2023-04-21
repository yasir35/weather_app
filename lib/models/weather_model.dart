class WeatherData {
  final double temperature;
  final String description;
  final String iconCode;

  WeatherData({
    required this.temperature,
    required this.description,
    required this.iconCode,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final mainData = json['main'];
    final weatherData = json['weather'][0];
    return WeatherData(
      temperature: mainData['temp'],
      description: weatherData['description'],
      iconCode: weatherData['icon'],
    );
  }
}
