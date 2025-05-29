import 'package:flutter/material.dart';

/// Mapeia código OpenWeather (ex: '01d') para código AccuWeather (1 a 44)
final Map<String, int> openToAccuMap = {
  '01d': 1,   // Ensolarado
  '01n': 33,  // Noite clara
  '02d': 3,   // Poucas nuvens dia
  '02n': 35,  // Poucas nuvens noite
  '03d': 6,
  '03n': 36,
  '04d': 7,
  '04n': 38,
  '09d': 12,
  '09n': 39,
  '10d': 13,
  '10n': 40,
  '11d': 15,
  '11n': 41,
  '13d': 22,
  '13n': 43,
  '50d': 19,
  '50n': 20,
};

Widget obterIcone(String codigo, {double size = 30.0}) {
  final int? accuweatherCode = openToAccuMap[codigo];
  if (accuweatherCode == null) {
    return const Icon(Icons.help_outline);
  }

  final String assetPath = 'assets/images/$accuweatherCode.png';
  return SizedBox(
    width: size,
    height: size,
    child: FittedBox(
      fit: BoxFit.contain,
      child: Image.asset(
        assetPath,
        scale: 0.1,
      ),
    ),
  );
}
