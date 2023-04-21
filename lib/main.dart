import 'package:flutter/material.dart';
import 'package:weather_app/loading.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.deepPurpleAccent),
      ),
      home: const LoadingPage(),
    );
  }
}
