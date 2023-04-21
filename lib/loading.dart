import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_app/weather.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<LoadingPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WeatherScreen()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xff29b1dd), Color(0xff33aadd), Color(0xff2dc7e9)],
      )),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Mausami',
            style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lobster-Regular'),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/3.png',
                width: 200.0,
                height: 200.0,
              ),
              const SizedBox(height: 30.0),
              const SpinKitWanderingCubes(
                color: Colors.blue,
                size: 50.0,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
