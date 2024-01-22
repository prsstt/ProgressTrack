// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BodyMeasureScreen extends StatefulWidget {
  @override
  _BodyMeasureScreenState createState() => _BodyMeasureScreenState();
}

class _BodyMeasureScreenState extends State<BodyMeasureScreen> {
  List<double> gyroscopeValues = [0, 0, 0];
  List<double> accelerometerValues = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    _startSensorListeners();
  }

  void _startSensorListeners() {
    gyroscopeEventStream().listen((GyroscopeEvent event) {
      setState(() {
        gyroscopeValues = [event.x, event.y, event.z];
      });
    });

    accelerometerEventStream().listen((AccelerometerEvent event) {
      setState(() {
        accelerometerValues = [event.x, event.y, event.z];
      });
    });
  }

  double calculateCircumference() {
    // Algorytm do obliczania obwodu
    // Przykładowo, możemy użyć średniej z odczytów z żyroskopu lub akcelerometru
    // w zależności od dostępnych danych.
    double averageGyro = gyroscopeValues.reduce((a, b) => a + b) / 3;
    double averageAcc = accelerometerValues.reduce((a, b) => a + b) / 3;

    // Przykładowy sposób obliczania obwodu na podstawie średniej
    double circumference = (averageGyro + averageAcc) / 2;

    return circumference;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Body Measurements'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Gyroscope Values: $gyroscopeValues'),
            Text('Accelerometer Values: $accelerometerValues'),
            ElevatedButton(
              onPressed: () {
                double circumference = calculateCircumference();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Obwód: $circumference cm'),
                  ),
                );
              },
              child: Text('Zmierz obwód'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BodyMeasureScreen(),
  ));
}
